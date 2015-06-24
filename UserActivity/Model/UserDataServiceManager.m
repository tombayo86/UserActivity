//
//  ServiceManager.m
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "UserDataServiceManager.h"
#import "ParserProtocol.h"
#import "ParseParser.h"
#import "UAModel.h"
#import "DataServiceProtocol.h"

@interface UserDataServiceManager()

@property (weak, nonatomic) id<DataServiceProtocol> dataService;
@property (strong, nonatomic) ParseService *parseService;


@property (weak, nonatomic) id<ParserProtocol> parser;
@property (strong, nonatomic) ParseParser *parseParser;

@property (strong, nonatomic) UAModel *userActivityModel;

@end

@implementation UserDataServiceManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupParse];
        self.userActivityModel = [UAModel sharedModel];
    }
    return self;
}

-(void)setupParse
{
    self.dataService = self.parseService;
    self.parser = self.parseParser;
}

-(void)getDataFromService
{
    __weak UserDataServiceManager *weakSelf = self;
    [self.dataService getUserActivitesWithCompletion:^(NSArray * data, NSError *error){
        if(error) {
            [weakSelf.delegate serviceError:error];
        } else {
            [weakSelf.userActivityModel setUserActivities:[self.parser parseUserActivities:data]];
        }
    }];
    [self.dataService getUserProfilePictureWithCompletion:^(UIImage *image, NSError *error){
        if(error) {
            [weakSelf.delegate serviceError:error];
        } else {
            [weakSelf.userActivityModel setUserProfilePicture:image];
        }
    }];
}

-(void)logout
{
    [self.dataService logout];
}

#pragma mark - Custom getters and setters

-(ParseService *)parseService
{
    if(!_parseService) _parseService = [[ParseService alloc] init];
    
    return _parseService;
}

-(ParseParser *)parseParser
{
    if(!_parseParser) _parseParser = [[ParseParser alloc] init];
    
    return _parseParser;
}


@end
