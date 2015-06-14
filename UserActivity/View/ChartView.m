//
//  ChartView.m
//  UserActivity
//
//  Created by el mariachi on 14/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "ChartView.h"

@implementation ChartView

-(void)loadView: (NSArray *)userActivities
{
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    CGRect frameRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 200);
    self = [super initWithFrame:frameRect];
    
    return self;
}


@end
