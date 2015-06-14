//
//  UserActivity.h
//  UserActivity
//
//  Created by el mariachi on 14/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserActivity : NSObject

@property (strong, nonatomic) NSDate *startsAt;
@property (strong, nonatomic) NSDate *endsAt;
@property (strong, nonatomic) NSString *type;

@end
