//
//  ParseService.m
//  UserActivity
//
//  Created by el mariachi on 10/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "ParseService.h"

@interface ParseService()

@property (nonatomic, copy) void (^userActivitiesCompletionHandler)(NSArray *, NSError*);
@property (nonatomic, copy) void (^userProfilePictureCompletionHandler)(UIImage *, NSError *);
@end

@implementation ParseService

-(void) getUserActivitesWithCompletion:(void (^)(NSArray *, NSError *))handler
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserActivity"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *data, NSError *error) {
        handler(data, error);
    }];
}

-(void)getUserProfilePictureWithCompletion:(void (^)(UIImage *, NSError *))handler
{
    self.userProfilePictureCompletionHandler = handler;
    
    PFUser *user = [PFUser currentUser];

    PFFile *pictureFile = [user objectForKey:@"userImage"];
    
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        handler([UIImage imageWithData:data], error);
    }];

}

-(void)logout
{
    [PFUser logOut];
}
@end
