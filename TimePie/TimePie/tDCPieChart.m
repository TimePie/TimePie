//
//  tDCPieChart.m
//  TimePie
//
//  Created by 大畅 on 14-4-7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "tDCPieChart.h"
#import "BasicUIColor+UIPosition.h"

@implementation tDCPieChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initLabels];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawSectorWithColor:REDNO1];
    [self drawCircleInContext:context withRadius:42 color:RedNO1_light];
    [self drawCircleInContext:context withRadius:30 color:WHITE_COLOR];
}

-(void)drawCircleInContext:(CGContextRef)context withRadius:(int)radius color:(UIColor*)color
{
    UIGraphicsPushContext(context);
    
    CGContextSetLineWidth(context, 2.0);
    CGContextBeginPath(context);
    CGContextAddArc(context, CIRCLE_CENTER_POS, CIRCLE_CENTER_POS, radius, 0, 2*M_PI, YES);
    CGContextClosePath(context);
    
    CGContextSetRGBFillColor(context, CGColorGetComponents([color CGColor])[0], CGColorGetComponents([color CGColor])[1], CGColorGetComponents([color CGColor])[2], CGColorGetComponents([color CGColor])[3]);
    
    CGContextDrawPath(context, kCGPathFill);

    UIGraphicsPopContext();
}

- (void)drawSectorWithColor:(UIColor*)color
{
    CGFloat percentage = 0.7f;
    CGFloat radius = 42;
    //fixed start point
    CGFloat starttime = -M_PI/2;
    //full value * percentage
    CGFloat endtime = 2 * M_PI * percentage - M_PI/2;
    //draw arc
    CGPoint center = CGPointMake(CIRCLE_CENTER_POS,CIRCLE_CENTER_POS);
    UIBezierPath *arc = [UIBezierPath bezierPath]; //empty path
    [arc moveToPoint:center];
    CGPoint next;
    next.x = center.x + radius * cos(starttime);
    next.y = center.y + radius * sin(starttime);
    [arc addLineToPoint:next]; //go one end of arc
    [arc addArcWithCenter:center radius:radius startAngle:starttime endAngle:endtime clockwise:YES]; //add the arc
    [arc addLineToPoint:center]; //back to center
    
    [color set];
    [arc fill];
}

#pragma mark - UIView
- (void)initLabels
{
    UILabel *percentageValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 35, 60, 30)];
    percentageValueLabel.text = @"70";
    percentageValueLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:26.f];
    percentageValueLabel.textColor = REDNO1;
    [self addSubview:percentageValueLabel];
    [self bringSubviewToFront:percentageValueLabel];
    
    UILabel *percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 40, 20, 10)];
    percentageLabel.text = @"%";
    percentageLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14.f];
    percentageLabel.textColor = REDNO1;
    [self addSubview:percentageLabel];
    [self bringSubviewToFront:percentageLabel];
}

@end
