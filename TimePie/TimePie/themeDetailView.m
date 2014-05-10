//
//  themeDetailView.m
//  TimePie
//
//  Created by 大畅 on 14-5-10.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "themeDetailView.h"

@implementation themeDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i < 5; i++)
    {
        CGRect rectangle = CGRectMake(24 * i, 14, 20, 20);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPathRef roundedRectPath = [self newPathForRoundedRect:rectangle radius:5];
        [(UIColor*)[colorArray objectAtIndex:i] set];
        CGContextAddPath(context, roundedRectPath);
        CGContextFillPath(context);
        CGPathRelease(roundedRectPath);
    }
}

- (void)initThemeWithColorBoard:(NSArray *)colors
{
    colorArray = colors;
}

@end
