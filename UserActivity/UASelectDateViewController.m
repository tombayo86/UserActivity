//
//  SelectDateViewController.m
//  UserActivity
//
//  Created by el mariachi on 23/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "UASelectDateViewController.h"
#import "UAModel.h"

@interface UASelectDateViewController ()

@property (strong, nonatomic) NSCalendar *cal;
@property (strong, nonatomic) NSTimeZone* destinationTimeZone;

@property (strong, nonatomic) UAModel *userActivitiesModel;

@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@end

@implementation UASelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userActivitiesModel = [UAModel sharedModel];
}

#pragma mark Custom getters
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

#pragma mark Private methods

-(IBAction)didSelectDates:(id)sender
{
    BOOL userActivitiesExistsInSelectedPeriod = [self.userActivitiesModel userActivitiesExistsInPeriodBetweenStartDate:[self startDate] andEndDate:[self endDate]];
                                                      
    if (userActivitiesExistsInSelectedPeriod) {
        
        [self dismissViewControllerAnimated:NO completion:nil];

        [self.delegate dateSelectDidFinishWithStartDate:[self startDate] andEndDate:[self endDate]];
        
    } else {
         UIAlertController *alertController =
         [UIAlertController alertControllerWithTitle:@"We have a problem"
         message:@"No activities found in that period of time"
         preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction *okAction = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault handler:nil];
        
         [alertController addAction:okAction];
         
         [self presentViewController:alertController animated:YES completion:nil];
     
     }
}

-(IBAction)didCancelSelectDates:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.delegate didCancelTheSelection];
}

@end
