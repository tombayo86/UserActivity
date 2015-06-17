//
//  SelectDateView.m
//  UserActivity
//
//  Created by el mariachi on 16/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "SelectDateView.h"

@interface SelectDateView()

@property (strong, nonatomic) NSCalendar *cal;
@property (strong, nonatomic) NSTimeZone* destinationTimeZone;

@end
@implementation SelectDateView


-(NSDate *)startDate
{
    NSDateComponents *components = [self.cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.startDatePicker.date];
    
    NSInteger timeZoneOffset = [self.destinationTimeZone secondsFromGMTForDate:self.startDatePicker.date] / 3600;
    [components setHour:timeZoneOffset];
    [components setMinute:0];
    [components setSecond:0];
    
    return [self.cal dateFromComponents:components];
}

-(NSDate *)endDate
{
    NSDateComponents *components = [self.cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.endDatePicker.date];
    
    NSInteger timeZoneOffset = [self.destinationTimeZone secondsFromGMTForDate:self.endDatePicker.date] / 3600;
    [components setHour:timeZoneOffset + 23];
    [components setMinute:59];
    [components setSecond:59];
    
    return [self.cal dateFromComponents:components];
}

-(NSTimeZone *)destinationTimeZone
{
    if(!_destinationTimeZone) _destinationTimeZone = [NSTimeZone systemTimeZone];
    return _destinationTimeZone;
}

-(NSCalendar *)cal
{
    if(!_cal) _cal = [NSCalendar currentCalendar];
    return _cal;
}

@end
