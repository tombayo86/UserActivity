//
//  DataService.h
//  UserActivity
//
//  Created by el mariachi on 11/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataServiceDelegate <NSObject>

-(void)userActivitiesDownloadDidFinish: (NSArray *)data;
-(void)serviceError:(NSError *)error;

@end

@protocol DataService <NSObject>

@property (weak, nonatomic) id<DataServiceDelegate> delegate;

-(void)getUserActivites;

@end


