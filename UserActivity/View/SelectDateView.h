//
//  SelectDateView.h
//  UserActivity
//
//  Created by el mariachi on 16/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDateView : UIView

@property (nonatomic, weak) IBOutlet UIDatePicker *startDatePicker;

@property (nonatomic, weak) IBOutlet UIDatePicker *endDatePicker;

-(NSDate *)startDate;
-(NSDate *)endDate;

@end
