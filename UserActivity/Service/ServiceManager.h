//
//  ServiceManager.h
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseService.h"

@protocol ServiceManagerDelegate <NSObject>

-(void)userLoginError;
-(void)userDataDownloadDidFinish: (NSArray *)userData;
-(void)userDataDownloadProgress: (NSNumber *)progress;
-(void)serviceError: (NSError *)error;

@end

@interface ServiceManager : NSObject

-(void)logUserIn:(NSString *)username withPassword:(NSString *)password;

@property (weak, nonatomic) id<ServiceManagerDelegate> delegate;

@end
