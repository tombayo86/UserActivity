//
//  ViewController.m
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "UserActivityViewController.h"
#import "ChartViewCell.h"
#import "ActivityViewCell.h"


@interface UserActivityViewController ()

@property (strong, nonatomic) ServiceManager *serviceManager;
@property (strong, nonatomic) PFLogInViewController *logInViewController;
@property (nonatomic, getter=isUserLoggedIn) BOOL userLoggedIn;
@property (strong, nonatomic) NSArray *userActivities;
@property (strong, nonatomic) NSArray *currentChartData;

@end

@implementation UserActivityViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Hide content until login succeed
    self.tableView.hidden = YES;
    self.toolBar.hidden = YES;
    
    self.logInViewController.delegate = self;
    self.logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
    
    //Fill out the form
    self.logInViewController.logInView.usernameField.text = @"test";
    self.logInViewController.logInView.passwordField.text = @"asd";
    
    self.serviceManager.delegate = self;
    
}

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

-(PFLogInViewController *)logInViewController
{
    if(!_logInViewController) _logInViewController = [[PFLogInViewController alloc] init];
    
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
    return 1 + [self.currentChartData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ChartViewCell *cell = (ChartViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chartCell"];
        
        if(!cell) cell = [[ChartViewCell alloc] initWithFrame:CGRectZero];
        
        if(self.currentChartData){
            [cell.chartView loadView: self.currentChartData];
            [cell.chartView setNeedsDisplay];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        ActivityViewCell *cell = (ActivityViewCell *)[tableView dequeueReusableCellWithIdentifier:@"activityCell"];
        
        if(!cell) cell = [[ActivityViewCell alloc] initWithFrame:CGRectZero];
        
        NSString *activityTitle = [self.currentChartData[indexPath.row - 1] valueForKey:@"type"];
        cell.textLabel.text = activityTitle;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 300;
    }
    return 60;
}

#pragma mark PFLogInViewController Delegate methods

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
  
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

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    self.userLoggedIn = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.serviceManager getUserData];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
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
    
    self.currentChartData = [self filterUserActivitiesWithStartDate: nil andEndDate: nil];
    
    [self.tableView reloadData];
    
    [self.activityIndicator stopAnimating];
    
    self.tableView.hidden = NO;
    self.toolBar.hidden = NO;
}

-(void)serviceError:(NSError *)error
{
    
}

#pragma mark Private methods

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

#pragma mark Navigation

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    
    [self presentViewController:self.logInViewController animated:NO completion:nil];
}
@end
