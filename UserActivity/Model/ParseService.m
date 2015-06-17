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

-(void) getUserActivites
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserActivity"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *data, NSError *error) {
        if (!error) {
            [self.delegate userActivitiesDownloadDidFinish:data];
        } else {
            [self.delegate serviceError:error];
        }
    }];
}

@end
