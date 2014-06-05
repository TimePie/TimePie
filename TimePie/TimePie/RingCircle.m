//
//  RingCircle.m
//  TimePie
//
//  Created by Max Lu on 6/5/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "RingCircle.h"

@implementation RingCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
     withPercentage:(double)percentage
          withColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        radius= frame.size.width/2;
        innerRadius= frame.size.width/6;
        
        NSLog(@"init ring circle!");
        circleView = [[UIView alloc] initWithFrame:CGRectMake(-innerRadius, -innerRadius, innerRadius*2, innerRadius*2)];
        circleView.layer.cornerRadius = innerRadius;
        circleView.layer.shadowColor = [color CGColor];//(__bridge CGColorRef)(color);
        circleView.layer.shadowOffset = CGSizeMake(0, 0);
        circleView.layer.shadowRadius = 3;
        circleView.layer.shadowOpacity = 1;
        
        circleView.backgroundColor = color;
        [self addSubview:circleView];
        
        
        
        float ringRadius = innerRadius + (radius-innerRadius)*percentage/100;
        
        ringView  = [[UIView alloc] initWithFrame:CGRectMake(-ringRadius, -ringRadius, ringRadius*2, ringRadius*2)];
        ringView.layer.cornerRadius = ringRadius;
        ringView.alpha = .2;
        
        ringView.layer.shadowColor = [color CGColor];//(__bridge CGColorRef)(color);
        ringView.layer.shadowOffset = CGSizeMake(0, 0);
        ringView.layer.shadowRadius = 3;
        ringView.layer.shadowOpacity = 1;
        
        ringView.backgroundColor = color;
        [self addSubview:ringView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
