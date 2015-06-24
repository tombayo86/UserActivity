//
//  ViewController.h
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "UserDataServiceManager.h"
#import "UASelectDateViewController.h"

@interface UAViewController : UIViewController <PFLogInViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, ServiceManagerDelegate, SelectDateViewControllerDelegate>

- (IBAction)logout:(id)sender;

@end

