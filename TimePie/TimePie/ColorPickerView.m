//
//  ColorPickerView.m
//  TimePie
//
//  Created by 大畅 on 14/6/7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "ColorPickerView.h"
#import "BasicUIColor+UIPosition.h"
#import "ColorThemes.h"

#define COLOR_BUTTON_START_COUNT 501

@implementation ColorPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = MAIN_UI_COLOR;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    NSArray *availableColorList = [[ColorThemes colorThemes] getAvailableColors];
    _CPV_mainVessel = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 68)];
    _CPV_mainVessel.contentSize = CGSizeMake(SCREEN_WIDTH * availableColorList.count/5, 68);
    _CPV_mainVessel.showsHorizontalScrollIndicator = NO;
    [self addSubview:_CPV_mainVessel];
    
    for (int i = 0; i < availableColorList.count; i++)
    {
        UIButton *colorButton = [[UIButton alloc] initWithFrame:CGRectMake(15 + (44 + 10) * i, 12, 44, 44)];
        colorButton.backgroundColor = [[ColorThemes colorThemes] getColorAt:[[availableColorList objectAtIndex:i] intValue]];
        colorButton.tag = COLOR_BUTTON_START_COUNT + [[availableColorList objectAtIndex:i] intValue];
        [colorButton addTarget:self action:@selector(colorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self setRoundedView:colorButton toDiameter:40];
        [_CPV_mainVessel addSubview:colorButton];
    }
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    roundedView.clipsToBounds = YES;
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
    
    roundedView.layer.borderWidth = 4;
    roundedView.layer.borderColor = [[UIColor whiteColor] CGColor];
}

#pragma mark - target action

- (void)colorButtonPressed:(id)sender
{
    int colorTag = [sender tag];
    UIColor *tColor = [[ColorThemes colorThemes] getColorAt:colorTag - COLOR_BUTTON_START_COUNT];
    [_delegate sendChosenColorWithColor:tColor ColorTag:colorTag - COLOR_BUTTON_START_COUNT];
}

@end
