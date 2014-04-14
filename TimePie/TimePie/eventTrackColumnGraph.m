//
//  eventTrackColumnGraph.m
//  TimePie
//
//  Created by 大畅 on 14-4-15.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "eventTrackColumnGraph.h"
#import "BasicUIColor+UIPosition.h"

@implementation eventTrackColumnGraph

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
    for (int i = 0; i < columnCount; i++)
    {
        CGRect rectangle = CGRectMake(230 - 7*i, 40-15, 5, 15);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, CGColorGetComponents([REDNO1 CGColor])[0], CGColorGetComponents([REDNO1 CGColor])[1], CGColorGetComponents([REDNO1 CGColor])[2], 0.3);
        CGContextFillRect(context, rectangle);
    }
}

- (void)initColumnGraphWithColumnCount:(NSInteger)cCount
{
    columnCount = cCount;
}


@end
