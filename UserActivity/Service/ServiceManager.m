//
//  ServiceManager.m
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "ServiceManager.h"

@interface ServiceManager()

@property (strong, nonatomic) ParseService *parseService;

@property (strong, nonatomic) id<DataService> dataService;

@end

@implementation ServiceManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataService = self.parseService;
    }
    return self;
}

-(void)logUserIn:(NSString *)username withPassword:(NSString *)password
{
   // [self.dataService logUserIn: login withPassword: password];
}

-(void)loginError: (NSError *)error
{
    [self.delegate userLoginError];
}

-(void)loginSucces
{
    [self getUserData];
}

-(void)getUserData
{
    
}

#pragma mark - Custom getters and setters

-(ParseService *)parseService
{
    if(!_parseService) _parseService = [[ParseService alloc] init];
    
    return _parseService;
}



@end
