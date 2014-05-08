//
//  themeView.m
//  TimePie
//
//  Created by 大畅 on 14-5-7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "themeView.h"
#import "BasicUIColor+UIPosition.h"

@implementation themeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initThemeLabel
{
    _themeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 60, 20)];
    _themeNameLabel.text = themeName;
    _themeNameLabel.textColor = MAIN_UI_COLOR;
    [self addSubview:_themeNameLabel];
}

- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i < 3; i++)
    {
        CGRect rectangle = CGRectMake(60 + 24 * i, 14, 20, 20);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPathRef roundedRectPath = [self newPathForRoundedRect:rectangle radius:5];
        [(UIColor*)[_themeColorArray objectAtIndex:i] set];
        CGContextAddPath(context, roundedRectPath);
        CGContextFillPath(context);
        CGPathRelease(roundedRectPath);
    }
}

#pragma mark - utility - draw round radius rect

- (CGPathRef) newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
}

#pragma mark - public methods
- (void)initThemeNameWithString:(NSString *)name ColorBoard:(NSMutableArray *)colors
{
    themeName = name;
    _themeColorArray = colors;
    [self initThemeLabel];
}

@end
