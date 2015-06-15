//
//  ChartView.m
//  UserActivity
//
//  Created by el mariachi on 14/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "ChartView.h"
#import "UserActivity.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ChartView()

@property (strong, nonatomic) NSArray *data;

@end

@implementation ChartView

-(void)loadView: (NSArray *)chartData
{
    self.data = chartData;
    
    [self setNeedsDisplay];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    CGRect frameRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 300);
    self = [super initWithFrame:frameRect];
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    if(self.data) {
        int totalTime;
        for (NSObject *obj in self.data)
        {
            int minutes = [[obj valueForKey:@"minutes"] intValue];
            totalTime += minutes;
        }
        
        float oneMinuteAngle = 360.0f / totalTime;
        
        float startAngle = 0.0;
        float endAngle;
        int minutes;
        
        for (NSObject *obj in self.data)
        {
                minutes += [[obj valueForKey:@"minutes"] intValue];
                
                endAngle = (float) minutes * oneMinuteAngle;
                
                CGMutablePathRef arc = CGPathCreateMutable();
                CGPathAddArc(arc, NULL,
                             self.frame.size.width/2, self.frame.size.height/2,
                             80,
                             DEGREES_TO_RADIANS(startAngle),
                             DEGREES_TO_RADIANS(-endAngle),
                             YES);
                
                CGFloat lineWidth = 80.0;
                CGPathRef strokedArc =
                CGPathCreateCopyByStrokingPath(arc, NULL, lineWidth, kCGLineCapButt, kCGLineJoinMiter, 10);
                
                CAShapeLayer *segment = [CAShapeLayer layer];
                
                CGFloat redLevel    = rand() / (float) RAND_MAX;
                CGFloat greenLevel  = rand() / (float) RAND_MAX;
                CGFloat blueLevel   = rand() / (float) RAND_MAX;
                
                segment.fillColor = [UIColor colorWithRed:redLevel green:greenLevel blue:blueLevel alpha:1].CGColor;
            
                segment.strokeColor = [UIColor blackColor].CGColor;
                segment.lineWidth = 1.0;
                segment.path = strokedArc;
            
                [self.layer addSublayer:segment];
            
                
                startAngle = -endAngle;
            
        }
    }
}


@end
