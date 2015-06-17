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

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.selectDatesView.hidden = YES;
    
    self.logInViewController.delegate = self;
    self.logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
    
    //Fill out the form
    self.logInViewController.logInView.usernameField.text = @"test";
    self.logInViewController.logInView.passwordField.text = @"asd";
    
    //set serviceManager delegate
    self.serviceManager.delegate = self;
    
    //Add background image
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
}

//Hiding chart
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetProgressBar];
    
    [self dataContentHidden:YES];
}

//Showing loginViewController if the user is not logged in
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     if(!self.isUserLoggedIn) [self presentViewController:self.logInViewController animated:NO completion:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.userImageView.image = nil;
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
        
        [weakSelf.activityIndicator startAnimating];
    
        [weakSelf.serviceManager getData];
    }];
}

#pragma mark Service Manager Delegate methods

-(void)userActivitiesDownloadDidFinish:(NSArray *)userData
{
    self.userActivities = userData;
    
    //Filtering recieved data according to selected dates
    self.currentChartData = [self filterUserActivitiesWithStartDate: nil andEndDate: nil];
    
    PFUser *user = [PFUser currentUser];
    
    PFFile *pictureFile = [user objectForKey:@"userImage"];
    
    UAViewController __weak *weakSelf = self;
    
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            
            //set user profile picture
            self.userImageView.image = [UIImage imageWithData:data];
            
             //update progress view
            [weakSelf.progressBar setProgress:1.0f animated:YES];
           
            [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakSelf.progressBar.alpha = 0.0;
            } completion:^(BOOL finished) {
                weakSelf.progressBar.hidden = YES;
                [weakSelf prepareChartReloadTableViewAndShowAnimation];
            }];
        }
        else {
            [self serviceError:error];
        }
    }];
    
}

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
    self.chartView.chartData = self.currentChartData;
    [self.chartView setNeedsDisplay];
    
    //Reloading the tableview
    [self.tableView reloadData];
    
    [self.activityIndicator stopAnimating];
    
    //Showing thie content
    [self showAndAnimate];
}

//Filtering user activities by start date and end date
//Converting data to objects recognizable by chart (array of objects with attributes: type and minutes)
-(NSArray *)filterUserActivitiesWithStartDate: (NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSMutableArray *resultArray = [NSMutableArray new];
    NSArray *results = self.userActivities;
    
    if(startDate && endDate) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(startsAt >= %@ ) AND (endsAt <= %@)", startDate, endDate];
        results = [self.userActivities filteredArrayUsingPredicate:predicate];
    }
    
    NSArray *types = [results valueForKeyPath:@"@distinctUnionOfObjects.type"];
    for (NSString *type in types)
    {
        NSMutableDictionary *entry = [NSMutableDictionary new];
        [entry setObject:type forKey:@"type"];
        
        NSArray *typeDates = [results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", type]];
        
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
    [PFUser logOut];
    
    [self presentViewController:self.logInViewController animated:NO completion:nil];
}

#pragma mark Select Dates View methods

//Showing action sheet to select start and end dates
- (IBAction)selectDates:(id)sender {
    
    [self dataContentHidden:YES];
    
    self.selectDatesView.hidden = NO;
}

-(IBAction)didSelectDates:(id)sender
{
    self.currentChartData = [self filterUserActivitiesWithStartDate:[self.selectDatesView startDate]
                                                         andEndDate:[self.selectDatesView endDate]];
    
    //Check if current data has results in given period of time.
    //If yes - show chart and tableview
    //If not - show alert message
    if ([self.currentChartData count] > 0) {
        
        self.selectDatesView.hidden = YES;
        
        [self.activityIndicator startAnimating];
        
        [self prepareChartReloadTableViewAndShowAnimation];
        
    } else {
        
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"We have a problem"
                                            message:@"No activities found in that period of time"
                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

-(IBAction)didCancelSelectDates:(id)sender
{
    self.selectDatesView.hidden = YES;
    
    [self dataContentHidden:NO];
}


@end
