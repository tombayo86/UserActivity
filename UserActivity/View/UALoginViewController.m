//
//  UALoginViewController.m
//  UserActivity
//
//  Created by el mariachi on 16/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "UALoginViewController.h"

@implementation UALoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    //create logo image
    self.logInView.logo.alpha = 0.0;
   
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    
    //Set background color for fields
    self.logInView.usernameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    self.logInView.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.logInView.logInButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    
    //Set border for login button
    [[self.logInView.logInButton layer] setBorderColor:[UIColor colorWithWhite:1.0 alpha:1.0].CGColor];
    [[self.logInView.logInButton layer] setBorderWidth:1.0];
}

//Reseting position of elements of the view
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.usernameField setFrame:CGRectMake(self.view.frame.size.width /2 - 125.0, 245.0, 250.0, 50.0)];
    [self.logInView.passwordField setFrame:CGRectMake(self.view.frame.size.width /2 - 125.0, 295.0, 250.0, 50.0)];
    [self.logInView.logInButton setFrame:CGRectMake(self.view.frame.size.width /2 - 125.0, 390.0, 250.0, 60.0)];
    
}

//Reseting properties of elements of the view
-(void)viewWillAppear:(BOOL)animated
{
    [self.logInView.passwordField setAlpha:1.0];
    [self.logInView.usernameField setAlpha:1.0];
    [self.logInView.logInButton setAlpha:1.0];
    
    [self viewDidLayoutSubviews];
}

//Animating log in view controlled when hiding it
- (void)hideWithAnimationAndCompletion :(void (^)(void))completionBlock
{
    
    [UIView animateWithDuration:0.1 delay: 0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.logInView.logInButton setFrame:CGRectMake(self.logInView.logInButton.frame.origin.x,
                                                        self.logInView.logInButton.frame.origin.y + 100,
                                                        self.logInView.logInButton.frame.size.width,
                                                        self.logInView.logInButton.frame.size.height)];
        [self.logInView.logInButton setAlpha:0.0];
    } completion:nil];
    
    [UIView animateWithDuration:0.1 delay: 0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.logInView.passwordField setFrame:CGRectMake(self.logInView.passwordField.frame.origin.x,
                                                          self.logInView.passwordField.frame.origin.y + 100,
                                                          self.logInView.passwordField.frame.size.width,
                                                          self.logInView.passwordField.frame.size.height)];
        [self.logInView.passwordField setAlpha:0.0];
    } completion:nil];
    
    [UIView animateWithDuration:0.1 delay: 0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.logInView.usernameField setFrame:CGRectMake(self.logInView.usernameField.frame.origin.x,
                                                          self.logInView.usernameField.frame.origin.y + 100,
                                                          self.logInView.usernameField.frame.size.width,
                                                          self.logInView.usernameField.frame.size.height)];
        [self.logInView.usernameField setAlpha:0.0];
    } completion:^(BOOL finished) {
        completionBlock();
    }];
    
}

@end
