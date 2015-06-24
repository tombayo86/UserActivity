//
//  DataService.h
//  UserActivity
//
//  Created by el mariachi on 11/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataServiceProtocol <NSObject>

-(void)getUserActivitesWithCompletion: (void (^)(NSArray *, NSError *))handler;
-(void)getUserProfilePictureWithCompletion: (void (^)(UIImage *, NSError *))handler;
-(void)logout;

@end


