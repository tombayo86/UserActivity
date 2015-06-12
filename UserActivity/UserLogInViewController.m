//
//  ViewController.m
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "UserLogInViewController.h"


@interface UserLogInViewController ()

@property (strong, nonatomic) ServiceManager *serviceManager;
@property (strong, nonatomic) PFLogInViewController *logInViewController;
@property (nonatomic, getter=isUserLoggedIn) BOOL userLoggedIn;

@end

@implementation UserLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logInViewController.delegate = self;
    self.logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.isUserLoggedIn) [self presentViewController:self.logInViewController animated:YES completion:nil];
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

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    self.userLoggedIn = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
   // [self.serviceManager getUserData];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

@end
