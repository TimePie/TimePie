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
    [self drawSectorWithColor:REDNO1];
    [self drawCircleInContext:context withRadius:42 color:_tDCLightColor];
    [self drawCircleInContext:context withRadius:30 color:WHITE_COLOR];
}

- (void)initInfosWithColor:(UIColor *)color lightColor:(UIColor *)lColor Name:(NSString *)eventName Percent:(CGFloat)percent PercentString:(NSString *)pString
{
    _tDCColor = color;
    _tDCLightColor = lColor;
    _tDCEventName = eventName;
    _tDCPercentage = percent;
    _tDCPercentageString = pString;
    [self initLabelsWithColor:_tDCColor];
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
    CGFloat percentage = _tDCPercentage;
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
    
    [_tDCColor set];
    [arc fill];
}

#pragma mark - UIView
- (void)initLabelsWithColor:(UIColor*)color
{
    UILabel *percentageValueLabel = [[UILabel alloc] initWithFrame:CGRectMake([self originXValue], 35, 60, 30)];
    percentageValueLabel.text = _tDCPercentageString;
    percentageValueLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:26.f];
    percentageValueLabel.textColor = color;
    [self addSubview:percentageValueLabel];
    [self bringSubviewToFront:percentageValueLabel];
    
    UILabel *percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 40, 20, 10)];
    percentageLabel.text = @"%";
    percentageLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14.f];
    percentageLabel.textColor = color;
    [self addSubview:percentageLabel];
    [self bringSubviewToFront:percentageLabel];
    
    UILabel *eventName = [[UILabel alloc] initWithFrame:CGRectMake(30, 95, 80, 30)];
    eventName.text = _tDCEventName;
    if (eventName.text.length > 2)
    {
        eventName.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.f];
        eventName.frame = CGRectMake(eventName.frame.origin.x - 8 * eventName.text.length / 4, eventName.frame.origin.y, eventName.frame.size.width, eventName.frame.size.height);
    }
    else eventName.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.f];
    eventName.textColor = color;
    [self addSubview:eventName];
    [self bringSubviewToFront:eventName];
}

- (CGFloat)originXValue
{
    CGFloat originX = 0;
    if (_tDCPercentage >= 0.1f)
    {
        originX = 33;
    }
    else originX = 42;
    return originX;
}

@end
