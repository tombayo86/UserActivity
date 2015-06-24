//
//  ServiceManager.h
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseService.h"
#import "DataServiceProtocol.h"

@protocol ServiceManagerDelegate <NSObject>

-(void)serviceError: (NSError *)error;

@end

@interface UserDataServiceManager : NSObject

@property (weak, nonatomic) id<ServiceManagerDelegate> delegate;
@property (nonatomic, getter=isUserLoggedIn) BOOL userLoggedIn;

-(void)getDataFromService;
-(void)logout;

@end
