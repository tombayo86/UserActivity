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

@property (strong, nonatomic) NSArray *colors;

@end

@implementation ChartView

//Static method to recieve coherent colors allover application according to data
+ (UIColor *)colorOfDataWithIndex: (NSUInteger)index
{
    static NSArray *colors = nil;
    if(!colors)
        colors = @[[UIColor colorWithRed:207.0/255.0 green:240.0/255.0 blue:158.0/255.0 alpha:1.0],
                               [UIColor colorWithRed:168.0/255.0 green:219.0/255.0 blue:168.0/255.0 alpha:1.0],
                               [UIColor colorWithRed:121.0/255.0 green:189.0/255.0 blue:154.0/255.0 alpha:1.0],
                               [UIColor colorWithRed:59.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0],
                               [UIColor colorWithRed:11.0/255.0 green:72.0/255.0 blue:107.0/255.0 alpha:1.0],
                               [UIColor colorWithRed:70.0/255.0 green:95.0/255.0 blue:93.0/255.0 alpha:1.0],
                               [UIColor colorWithRed:63.0/255.0 green:81.0/255.0 blue:81.0/255.0 alpha:1.0]];
    
    return colors[index];
}

//Drawing dougnat chart using Core Graphics
-(void)drawRect:(CGRect)rect
{
    if(self.chartData) {
        
        //Gather total time of activities
        int totalTime;
        for (NSObject *obj in self.chartData)
        {
            int minutes = [[obj valueForKey:@"minutes"] intValue];
            totalTime += minutes;
        }
        
        //Calculate the angle for one minute of activity
        float oneMinuteAngle = 360.0f / totalTime;
        
        float startAngle = 0.0;
        float endAngle;
        int minutes;
        
        //Drawing arcs with stroke around the center of view
        for (NSObject *obj in self.chartData)
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
                
                segment.fillColor = [ChartView colorOfDataWithIndex:[self.chartData indexOfObject:obj]].CGColor;
            
                segment.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
                segment.lineWidth = 2.0;
                segment.path = strokedArc;
            
                [self.layer addSublayer:segment];
            
                
                startAngle = -endAngle;
        }
    }
}

//Animating chart when the cell in table view is selected
-(void)selectPartWithIndex: (NSUInteger)index
{
    //Clearing animations of layers
    for (CAShapeLayer *layer in self.layer.sublayers) {
        [layer removeAllAnimations];
    }
    
    //Adding new animations of fade out
    for (CAShapeLayer *layer in self.layer.sublayers) {
        if([self.layer.sublayers indexOfObject:layer] != index) {
            CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeOutAnimation.duration = 0.2;
            fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.2];
            fadeOutAnimation.fillMode = kCAFillModeBoth;
            fadeOutAnimation.removedOnCompletion = NO;
            [layer addAnimation:fadeOutAnimation forKey:@"opacityOUT"];
        }
    }
}


@end
