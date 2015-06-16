//
//  ActivityViewCell.m
//  UserActivity
//
//  Created by el mariachi on 12/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "ActivityViewCell.h"

@implementation ActivityViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
}

@end
