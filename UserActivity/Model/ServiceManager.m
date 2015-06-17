//
//  ServiceManager.m
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "ServiceManager.h"
#import "Parser.h"
#import "ParseParser.h"

@interface ServiceManager()

@property (weak, nonatomic) id<DataService> dataService;
@property (strong, nonatomic) ParseService *parseService;


@property (weak, nonatomic) id<Parser> parser;
@property (strong, nonatomic) ParseParser *parseParser;

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
        [self setupParse];
        
    }
    return self;
}

-(void)setupParse
{
    self.dataService = self.parseService;
    self.parseService.delegate = self;
    self.parser = self.parseParser;
}

-(void)getData
{
    [self.dataService getUserActivites];
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

#pragma mark - DataService Delegate methods

-(void)userActivitiesDownloadDidFinish:(NSArray *)data
{
    [self.delegate userActivitiesDownloadDidFinish:[self.parser parse:data]];
}

-(void)serviceError:(NSError *)error
{
    [self.delegate serviceError:error];
}


@end
