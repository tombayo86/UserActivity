//
//  ViewController.m
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "UserLogInViewController.h"
#import "ServiceManager.h"
#import <Parse/Parse.h>

@interface UserLogInViewController ()

@property (strong, nonatomic) ServiceManager *serviceManager;

@end

@implementation UserLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.serviceManager getUserData];
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

@end
