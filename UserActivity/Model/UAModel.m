//
//  UAModel.m
//  UserActivity
//
//  Created by el mariachi on 23/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "UAModel.h"

@implementation UAModel

+ (UAModel *)sharedModel
{
    static UAModel *_instance;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(NSArray *)typesOfUserActivitiesfFilteredByStartDate: (NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSArray *filteredUserActivities = [self filterUserActivitiesByStartDate:startDate andEndDate:endDate];
    NSArray *types = [filteredUserActivities valueForKeyPath:@"@distinctUnionOfObjects.type"];
    
    return types;
}

-(NSArray *)durationsOfUserActivitiesFilteredByStartDate: (NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSMutableArray *resultArray = [NSMutableArray new];
    
    NSArray *filteredUserActivities = [self filterUserActivitiesByStartDate:startDate andEndDate:endDate];
    
    NSArray *types = [self typesOfUserActivitiesfFilteredByStartDate: startDate andEndDate:endDate];
    
    for (NSString *type in types)
    {
        NSArray *typeDates = [filteredUserActivities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", type]];
        
        int timeInMinutes = 0;
        for (int i = 0; i < typeDates.count; i++)
        {
            if([typeDates[i] isKindOfClass:[UserActivity class]]) {
                UserActivity *userActivity = typeDates[i];
                NSTimeInterval seconds = [userActivity.endsAt timeIntervalSinceDate:userActivity.startsAt];
                timeInMinutes += (seconds/60);
            }
        }
        
        [resultArray addObject:[NSNumber numberWithInt:timeInMinutes]];
    }
    
    return resultArray;
}

-(BOOL)userActivitiesExistsInPeriodBetweenStartDate: (NSDate *)startDate andEndDate:(NSDate *)endDate;
{
    if([[self filterUserActivitiesByStartDate:startDate andEndDate:endDate] count]) {
        return YES;
    }
    
    return NO;
}

-(NSArray *)filterUserActivitiesByStartDate: (NSDate *)startDate andEndDate:(NSDate *)endDate
{
    if(!startDate && !endDate){
        return self.userActivities;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(startsAt >= %@ ) AND (endsAt <= %@)", startDate, endDate];
    NSArray *filteredUserActivities = [self.userActivities filteredArrayUsingPredicate:predicate];
    
    return filteredUserActivities;
}

@end
