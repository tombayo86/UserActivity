//
//  Parser.h
//  UserActivity
//
//  Created by el mariachi on 14/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Parser <NSObject>

-(NSArray *)parse: (NSArray *)data;

@end
