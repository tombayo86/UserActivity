//
//  ChartView.h
//  UserActivity
//
//  Created by el mariachi on 14/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

@property (strong, nonatomic) NSArray *chartData;

-(void)loadView: (NSArray *)chartData;

@end
