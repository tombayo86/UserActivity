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

@interface UAViewController ()

@property (strong, nonatomic) ServiceManager *serviceManager;
@property (strong, nonatomic) UALoginViewController *logInViewController;
@property (nonatomic, getter=isUserLoggedIn) BOOL userLoggedIn;
@property (strong, nonatomic) NSArray *userActivities;
@property (strong, nonatomic) NSArray *currentChartData;

@end

@implementation UAViewController
{
    int chartYPosition;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //Hide content until login succeed
    self.tableView.hidden = YES;
    self.toolBar.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.logInViewController.delegate = self;
    self.logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
    
    //Fill out the form
    self.logInViewController.logInView.usernameField.text = @"test";
    self.logInViewController.logInView.passwordField.text = @"asd";
    
    //set serviceManager delegate
    self.serviceManager.delegate = self;
    
    //Add background image
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:bgImageView ];
    [self.view sendSubviewToBack:bgImageView ];
    
}

//Hiding chart
-(void)viewWillAppear:(BOOL)animated
{
    self.chartView.alpha = 0.0;
    self.toolBar.alpha = 0.0;
    self.tableView.hidden = YES;
    self.toolBar.hidden = YES;
}

//Showing loginViewController if the user is not logged in
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     if(!self.isUserLoggedIn) [self presentViewController:self.logInViewController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom setters and getters

-(ServiceManager *)serviceManager
{
    if(!_serviceManager) _serviceManager = [[ServiceManager alloc] init];
    
    return _serviceManager;
}

-(UALoginViewController *)logInViewController
{
    if(!_logInViewController) _logInViewController = [[UALoginViewController alloc] init];
    
    return _logInViewController;
}

-(NSArray *)userActivities
{
    //Insert condition to return filtered array when range of dates is selected
    /*if (<#condition#>) {
        
    }*/
    
    return _userActivities;
}


#pragma mark UITableViewDelegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentChartData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityViewCell *cell = (ActivityViewCell *)[tableView dequeueReusableCellWithIdentifier:@"activityCell"];
    
    //Setting up the cell (title, background ,selectiontype, alpha)
    NSString *activityTitle = [self.currentChartData[indexPath.row] valueForKey:@"type"];
    cell.textLabel.text = activityTitle;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.alpha = 0.0;
    UIColor *bgColor = [ChartView colorOfDataWithIndex:indexPath.row];
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

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
  
    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    self.userLoggedIn = YES;
    
    UAViewController __weak *weakSelf = self;
    
    [self.logInViewController hideWithAnimationAndCompletion:^{
        
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        [weakSelf.serviceManager getUserData];
    }];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Log in failed"
                                message:@""
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];

}

#pragma mark Service Manager Delegate methods



-(void)userDataDownloadDidFinish:(NSArray *)userData
{
    self.userActivities = userData;
    
    //Filtering recieved data according to selected dates
    self.currentChartData = [self filterUserActivitiesWithStartDate: nil andEndDate: nil];
    
    //Sending data to chart and rebuilding it
    self.chartView.chartData = self.currentChartData;
    [self.chartView setNeedsDisplay];
    
    //Reloading the tableview
    [self.tableView reloadData];
    
    [self.activityIndicator stopAnimating];
    
    //Showing thie content
    [self showWithAnimation];
}

//Handling service errors
-(void)serviceError:(NSError *)error
{
    
}

#pragma mark Private methods

//Filtering user activities by start date and end date
//Converting data to objects recognizable by chart (array of objects with attributes: type and minutes)
-(NSArray *)filterUserActivitiesWithStartDate: (NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSMutableArray *resultArray = [NSMutableArray new];
    NSArray *types = [self.userActivities valueForKeyPath:@"@distinctUnionOfObjects.type"];
    for (NSString *type in types)
    {
        NSMutableDictionary *entry = [NSMutableDictionary new];
        [entry setObject:type forKey:@"type"];
        
        NSArray *typeDates = [self.userActivities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", type]];
        
        int timeInMinutes = 0;
        for (int i = 0; i < typeDates.count; i++)
        {
            if([typeDates[i] isKindOfClass:[UserActivity class]]) {
                UserActivity *userActivity = typeDates[i];
                NSTimeInterval seconds = [userActivity.endsAt timeIntervalSinceDate:userActivity.startsAt];
                timeInMinutes += (seconds/60);
            }
        }
        
        [entry setObject:[NSNumber numberWithInt:timeInMinutes] forKey:@"minutes"];
        [resultArray addObject:entry];
    }
    
    return resultArray;
}

//Animations performed when the data is known and filtered
-(void)showWithAnimation
{
    self.tableView.hidden = NO;
    self.toolBar.hidden = NO;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.toolBar.alpha = 1.0;
    } completion:nil];
    
    [UIView animateWithDuration:0.7 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.chartView.alpha = 1.0;
    } completion:nil];
    
    
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
        ActivityViewCell* cell = (ActivityViewCell *)[self.tableView cellForRowAtIndexPath:cellPath];
        cell.alpha = 0;
        [UIView animateWithDuration:0.2 delay:1 + (0.2*row) options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.alpha = 1;
        } completion:nil];
    }
}

#pragma mark Navigation

//Action after logout button tapped
- (IBAction)logout:(id)sender
{
    [PFUser logOut];
    
    [self presentViewController:self.logInViewController animated:NO completion:nil];
}

//Showing action sheet to select start and end dates
- (IBAction)selectDates:(id)sender {
}
@end
