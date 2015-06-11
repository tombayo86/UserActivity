//
//  ParseService.m
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "ParseService.h"

@interface ParseService()



@end

@implementation ParseService

-(void) getUserDataWithRange:(NSDate *)startDate toDate:(NSDate *)endDate
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserActivity"];
    //Selecting data from selected date
//    if(startDate && endDate) {
//        [query whereKey:@"Name" equalTo:@"John"];
//    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.delegate userDataDownloadDidFinish:objects];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
            [self.delegate serviceError:error];
        }
    }];
}

-(void)getUserData
{
    [self getUserDataWithRange:nil toDate:nil];
}

@end
