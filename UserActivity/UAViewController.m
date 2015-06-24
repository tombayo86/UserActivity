//
//  ViewController.m
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "UAViewController.h"
#import "ActivityViewCell.h"
#import "UALoginViewController.h"
#import "UAModel.h"
#import "UASelectDateViewController.h"
#import "UserActivity.h"
#import "ChartView.h"
#import "UserDataServiceManager.h"

@interface UAViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ChartView *chartView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

//service and model
@property (strong, nonatomic) UserDataServiceManager *serviceManager;
@property (strong, nonatomic) UAModel *userActivityModel;

//additional viewcontrollers
@property (strong, nonatomic) UALoginViewController *logInViewController;

@property (strong, nonatomic) NSArray *typesOfUserActivities;
@property (strong, nonatomic) NSArray *durationsOfUserActivities;

@end

@implementation UAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.logInViewController.delegate = self;
    self.logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
    
    //Fill out the form
    self.logInViewController.logInView.usernameField.text = @"test";
    self.logInViewController.logInView.passwordField.text = @"asd";
    
    //set serviceManager delegate
    self.serviceManager.delegate = self;
    
    //creating model instance
    self.userActivityModel = [UAModel sharedModel];
        [self addBackgroundImage];
    
    [self dataContentHidden:YES];
    
    self.chartView.colors = @[[UIColor colorWithRed:207.0/255.0 green:240.0/255.0 blue:158.0/255.0 alpha:1.0],
                              [UIColor colorWithRed:168.0/255.0 green:219.0/255.0 blue:168.0/255.0 alpha:1.0],
                              [UIColor colorWithRed:121.0/255.0 green:189.0/255.0 blue:154.0/255.0 alpha:1.0],
                              [UIColor colorWithRed:59.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0],
                              [UIColor colorWithRed:11.0/255.0 green:72.0/255.0 blue:107.0/255.0 alpha:1.0],
                              [UIColor colorWithRed:70.0/255.0 green:95.0/255.0 blue:93.0/255.0 alpha:1.0],
                              [UIColor colorWithRed:63.0/255.0 green:81.0/255.0 blue:81.0/255.0 alpha:1.0]];
}

//Hiding chart
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetProgressBar];
    
    [self.userActivityModel addObserver:self
                             forKeyPath:@"userActivities"
                                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                context:nil];
    [self.userActivityModel addObserver:self
                             forKeyPath:@"userProfilePicture"
                                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                context:nil];
}

//Showing loginViewController if the user is not logged in
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     if(!self.serviceManager.isUserLoggedIn) [self presentViewController:self.logInViewController animated:NO completion:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.userActivityModel removeObserver:self forKeyPath:@"userActivities"];
    [self.userActivityModel removeObserver:self forKeyPath:@"userProfilePicture"];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self dataContentHidden:YES];
}

#pragma mark Custom setters and getters

-(UserDataServiceManager *)serviceManager
{
    if(!_serviceManager) _serviceManager = [[UserDataServiceManager alloc] init];
    
    return _serviceManager;
}

-(UALoginViewController *)logInViewController
{
    if(!_logInViewController) _logInViewController = [[UALoginViewController alloc] init];
    
    return _logInViewController;
}

#pragma mark UITableViewDelegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.typesOfUserActivities count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityViewCell *cell = (ActivityViewCell *)[tableView dequeueReusableCellWithIdentifier:@"activityCell"];
    
    //Setting up the cell (title, background ,selectiontype, alpha)
    NSString *activityTitle = self.typesOfUserActivities[indexPath.row];
    cell.textLabel.text = activityTitle;
    
    //Setting up the bg color
    UIColor *bgColor = self.chartView.colors[indexPath.row];
    cell.backgroundColor = bgColor;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//Selecting slice on chart
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.chartView selectPartWithIndex:indexPath.row];
}

#pragma mark PFLogInViewController Delegate methods

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    self.serviceManager.userLoggedIn = YES;
    
    __weak UAViewController *weakSelf = self;
    
    [self.logInViewController hideWithAnimationAndCompletion:^{
        
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        [weakSelf.activityIndicator startAnimating];
    
        [weakSelf.serviceManager getDataFromService];
    }];
}

#pragma mark Service Manager Delegate methods

//Handling service errors - presenting alert with info about error
-(void)serviceError:(NSError *)error
{
    NSString *errorString = [[error userInfo] objectForKey:@"error"];
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"We have a problem"
                                        message:errorString
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark Private methods

-(void)addBackgroundImage
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
}

-(void)resetProgressBar
{
    self.progressBar.hidden = NO;
    self.progressBar.alpha = 1.0;
    [self.progressBar setProgress:0.0f];
}

-(void)dataContentHidden: (BOOL) hidden
{
    self.tableView.hidden = hidden;
    self.toolBar.hidden = hidden;
    self.chartView.hidden = hidden;
    self.userImageView.hidden = hidden;
}

-(void)prepareChartReloadTableViewAndShowAnimation
{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    
    //Sending data to chart and rebuilding it
    self.chartView.chartData = self.durationsOfUserActivities;
    [self.chartView setNeedsDisplay];
    
    //Reloading the tableview
    [self.tableView reloadData];
    
    [self.activityIndicator stopAnimating];
    
    //Showing thie content
    [self showAndAnimate];
}

//Animations performed when the data is known and filtered
-(void)showAndAnimate
{
    //Set alpha to 0 and make visible
    self.chartView.alpha = 0.0;
    self.toolBar.alpha = 0.0;
    self.userImageView.alpha = 0.0;
    
    [self dataContentHidden:NO];
    
    //animate user image
    [UIView animateWithDuration:0.2
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.userImageView.alpha = 1.0;
                     }
                     completion:nil];

    
    //animate toolbar
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.toolBar.alpha = 1.0;
    }
                     completion:nil];
    
    //animate chartview
    [UIView animateWithDuration:0.7
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.chartView.alpha = 1.0;
    }
                     completion:nil];
    
    //animate cells
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
        ActivityViewCell* cell = (ActivityViewCell *)[self.tableView cellForRowAtIndexPath:cellPath];
        cell.alpha = 0;
        [UIView animateWithDuration:0.2
                              delay:1 + (0.2*row)
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            cell.alpha = 1;
        }
                         completion:nil];
    }
}

#pragma mark Navigation

//Action after logout button tapped
- (IBAction)logout:(id)sender
{
    [self.serviceManager logout];
    
    [self presentViewController:self.logInViewController animated:NO completion:nil];
}

#pragma mark SelectDatesViewController delegate methods

-(void)dateSelectDidFinishWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    self.typesOfUserActivities = [self.userActivityModel typesOfUserActivitiesfFilteredByStartDate:startDate andEndDate:endDate];
    self.durationsOfUserActivities = [self.userActivityModel durationsOfUserActivitiesFilteredByStartDate:startDate andEndDate:endDate];

    [self.activityIndicator startAnimating];
    
    [self prepareChartReloadTableViewAndShowAnimation];
}

-(void)didCancelTheSelection
{
    [self.activityIndicator startAnimating];
    [self prepareChartReloadTableViewAndShowAnimation];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"userActivities"]) {
        self.typesOfUserActivities = [self.userActivityModel typesOfUserActivitiesfFilteredByStartDate:nil andEndDate:nil];
        self.durationsOfUserActivities = [self.userActivityModel durationsOfUserActivitiesFilteredByStartDate:nil andEndDate:nil];
        [self prepareChartReloadTableViewAndShowAnimation];
        [self.progressBar setProgress:1.0];
    }
    if([keyPath isEqualToString:@"userProfilePicture"]) {
        self.userImageView.image = self.userActivityModel.userProfilePicture;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"selectDatesSegue"]) {
        UASelectDateViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}

@end
