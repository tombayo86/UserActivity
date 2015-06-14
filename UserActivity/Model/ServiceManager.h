//
//  ServiceManager.h
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseService.h"
#import "DataService.h"

@protocol ServiceManagerDelegate <NSObject>

-(void)userDataDownloadDidFinish: (NSArray *)userActivities;
-(void)serviceError: (NSError *)error;

@end

@interface ServiceManager : NSObject <DataServiceDelegate>

@property (weak, nonatomic) id<ServiceManagerDelegate> delegate;

-(void)getUserData;

@end
