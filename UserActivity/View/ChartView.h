//
//  ChartView.h
//  UserActivity
//
//  Created by el mariachi on 14/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

+ (UIColor *)colorOfDataWithIndex: (NSUInteger)index;

-(void)selectPartWithIndex: (NSUInteger)index;

@property (strong, nonatomic) NSArray *chartData;

@end
