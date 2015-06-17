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
@property (nonatomic) NSInteger selectedIndex;

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
    self.selectedIndex = -1;
    
    if(self.chartData) {
        
        [self clearLayer];
        
        //Gather total time of activities
        int totalTime = 0;
        for (NSObject *obj in self.chartData)
        {
            int minutes = [[obj valueForKey:@"minutes"] intValue];
            totalTime += minutes;
        }
        
        //Calculate the angle for one minute of activity
        float oneMinuteAngle = 360.0f / totalTime;
        
        float startAngle = 0.0;
        float endAngle = 0.0;
        int minutes = 0;
        int radius = rect.size.height/4;
        
        //Drawing arcs with stroke around the center of view
        for (NSObject *obj in self.chartData)
        {
                minutes += [[obj valueForKey:@"minutes"] intValue];
                
                endAngle = (float) minutes * oneMinuteAngle;
            
                CGMutablePathRef arc = CGPathCreateMutable();
                CGPathAddArc(arc, NULL,
                             self.frame.size.width/2, self.frame.size.height/2,
                             radius,
                             DEGREES_TO_RADIANS(startAngle),
                             DEGREES_TO_RADIANS(-endAngle),
                             YES);
            
            
                CGFloat lineWidth = rect.size.height/3.5;
                CGPathRef strokedArc =
                CGPathCreateCopyByStrokingPath(arc, NULL, lineWidth, kCGLineCapButt, kCGLineJoinMiter, 10);
                
                CAShapeLayer *segment = [CAShapeLayer layer];
                
                segment.fillColor = [ChartView colorOfDataWithIndex:[self.chartData indexOfObject:obj]].CGColor;
            
                segment.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
                segment.lineWidth = 2.0;
                segment.path = strokedArc;
            
                segment.opacity = 0.0;
                [self.layer addSublayer:segment];
            
                startAngle = -endAngle;
        }
        
        for (CAShapeLayer *layer in self.layer.sublayers) {
            CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeInAnimation.duration = 0.1;
            fadeInAnimation.beginTime = CACurrentMediaTime() + 1 + [self.layer.sublayers indexOfObject:layer] * 0.1;
            fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
            fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
            fadeInAnimation.fillMode = kCAFillModeBoth;
            fadeInAnimation.removedOnCompletion = NO;
            [layer addAnimation:fadeInAnimation forKey:@"showAnimation"];
        }
        
    }
}

//Clearing layer from old sublayers and animations
-(void)clearLayer
{
    [self.layer removeAllAnimations];
    self.layer.sublayers = nil;
}

//Animating chart when the cell in table view is selected
-(void)selectPartWithIndex: (NSUInteger)index
{
   
    //Adding new animations of fade out
    if(self.selectedIndex != index) {
         [self.layer removeAllAnimations];
        if(self.selectedIndex != -1) {
            CAShapeLayer *fadeOutLayer = self.layer.sublayers[self.selectedIndex];
            CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeOutAnimation.duration = 0.2;
            fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.3];
            fadeOutAnimation.fillMode = kCAFillModeBoth;
            fadeOutAnimation.removedOnCompletion = NO;
            [fadeOutLayer addAnimation:fadeOutAnimation forKey:@"fadeOutAnimation"];
            
            CAShapeLayer *fadeInLayer = self.layer.sublayers[index];
            CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeInAnimation.duration = 0.2;
            fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.3];
            fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
            fadeInAnimation.fillMode = kCAFillModeBoth;
            fadeInAnimation.removedOnCompletion = NO;
            [fadeInLayer addAnimation:fadeInAnimation forKey:@"fadeInAnimation"];
            
        }
        else {
            for (CAShapeLayer *layer in self.layer.sublayers) {
                if([self.layer.sublayers indexOfObject:layer] != index) {
                    
                    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    fadeOutAnimation.duration = 0.2;
                    fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];
                    fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.3];
                    fadeOutAnimation.fillMode = kCAFillModeBoth;
                    fadeOutAnimation.removedOnCompletion = NO;
                    [layer addAnimation:fadeOutAnimation forKey:@"fadeOutAnimation"];
                }
            }
        }
        self.selectedIndex = index;
    }
    
}


@end
