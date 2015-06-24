//
//  SelectDateViewController.h
//  UserActivity
//
//  Created by el mariachi on 23/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectDateViewControllerDelegate <NSObject>

-(void)dateSelectDidFinishWithStartDate: (NSDate *)startDate andEndDate: (NSDate *)endDate;
-(void)didCancelTheSelection;

@end

@interface UASelectDateViewController : UIViewController

@property (weak, nonatomic) id<SelectDateViewControllerDelegate> delegate;
@property (strong, nonatomic, readonly) NSDate *startDate;
@property (strong, nonatomic, readonly) NSDate *endDate;

@end
