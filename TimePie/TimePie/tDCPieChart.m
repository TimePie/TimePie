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
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCircleInContext:context withRadius:42 color:RedNO1_light];
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

@end
