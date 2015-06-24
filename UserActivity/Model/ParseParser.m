//
//  ParsePArser.m
//  UserActivity
//
//  Created by el mariachi on 14/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "ParseParser.h"
#import <Parse/Parse.h>
#import "UserActivity.h"

@implementation ParseParser

-(NSArray *)parseUserActivities:(NSArray *)userData
{
    NSMutableArray *userActivites = [[NSMutableArray alloc] init];
    
    for(PFObject* obj in userData){
        UserActivity *userActivity = [[UserActivity alloc] init];
        
        userActivity.type = [obj objectForKey:@"type"];
        userActivity.startsAt = [obj objectForKey:@"startsAt"];
        userActivity.endsAt = [obj objectForKey:@"endsAt"];
        
        [userActivites addObject:userActivity];
    }
    
    return userActivites;
}
@end
