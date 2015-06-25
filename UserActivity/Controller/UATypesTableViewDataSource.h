//
//  UserActivitiesTableViewDataSource.h
//  UserActivity
//
//  Created by el mariachi on 25/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ActivityViewCell.h"

@interface UATypesTableViewDataSource : NSObject <UITableViewDataSource>

-(instancetype)initWithItems: (NSArray *)items cellIdentifier: (NSString *) cellIdentifier configureCellBlock: (void (^)(ActivityViewCell *cell, NSInteger index))cellConfigureBlock;

@property (strong, nonatomic) NSArray *items;

@end
