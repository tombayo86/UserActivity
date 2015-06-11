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


+ (ServiceManager *)sharedManager
{
    static ServiceManager *_instance;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataService = self.parseService;
    }
    return self;
}

-(void)getUserData
{
    [self.dataService getUserData];
}

#pragma mark - Custom getters and setters

-(ParseService *)parseService
{
    if(!_parseService) _parseService = [[ParseService alloc] init];
    
    return _parseService;
}

#pragma mark - DataService Delegate methods


-(void)userDataDownloadDidFinish:(NSArray *)userData
{
    [self.delegate userDataDownloadDidFinish:userData];
}

-(void)userDataDownloadProgress:(NSNumber *)progress
{
    [self.delegate userDataDownloadProgress:progress];
}

-(void)serviceError:(NSError *)error
{
    [self.delegate serviceError:error];
}


@end
