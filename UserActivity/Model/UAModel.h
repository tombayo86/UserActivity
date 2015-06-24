//
//  UAModel.h
//  UserActivity
//
//  Created by el mariachi on 23/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserActivity.h"

@interface UAModel : NSObject

@property (strong, nonatomic) NSArray *userActivities;
@property (strong, nonatomic) UIImage *userProfilePicture;

+ (UAModel *)sharedModel;

-(NSArray *)typesOfUserActivitiesfFilteredByStartDate: (NSDate *)startDate andEndDate:(NSDate *)endDate;
-(NSArray *)durationsOfUserActivitiesFilteredByStartDate: (NSDate *)startDate andEndDate:(NSDate *)endDate;
-(BOOL)userActivitiesExistsInPeriodBetweenStartDate: (NSDate *)startDate andEndDate:(NSDate *)endDate;
@end
