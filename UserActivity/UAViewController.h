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
#import "SelectDateView.h"

@interface UAViewController : UIViewController <PFLogInViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, ServiceManagerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ChartView *chartView;
@property (weak, nonatomic) IBOutlet SelectDateView *selectDatesView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction)logout:(id)sender;
- (IBAction)selectDates:(id)sender;

- (IBAction)didSelectDates:(id)sender;
- (IBAction)didCancelSelectDates:(id)sender;


@end

