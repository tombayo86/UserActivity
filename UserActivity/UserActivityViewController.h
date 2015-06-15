//
//  ViewController.h
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceManager.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "UserActivity.h"

@interface UserActivityViewController : UIViewController <PFLogInViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, ServiceManagerDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)logout:(id)sender;

@end

