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
#import "ChartView.h"

@interface UAViewController : UIViewController <PFLogInViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, ServiceManagerDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ChartView *chartView;
- (IBAction)logout:(id)sender;
- (IBAction)selectDates:(id)sender;

@end

