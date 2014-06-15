//
//  TimeAdjustView.m
//  TimePie
//
//  Created by 大畅 on 14/6/14.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "TimeAdjustView.h"
#import "BasicUIColor+UIPosition.h"
#import "TimingItem1.h"
#import "ColorThemes.h"

@implementation TimeAdjustView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(266, 119, 44, 21)];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"taviewConfirm"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 119, 44, 21)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"taviewCancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    _taSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 50, 220, 30)];
    [_taSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _taSlider.tintColor = [UIColor colorWithRed:0 green:0.478 blue:1.f alpha:1.f];
    [self addSubview:_taSlider];
    
    _lhsItemView = [[UIView alloc] initWithFrame:CGRectMake(6, 45, 40, 40)];
    [self setRoundedView:_lhsItemView toDiameter:38.f];
    [self addSubview:_lhsItemView];
    
    _rhsItemView = [[UIView alloc] initWithFrame:CGRectMake(274, 45, 40, 40)];
    [self setRoundedView:_rhsItemView toDiameter:38.f];
    [self addSubview:_rhsItemView];
    
    _lhsItemName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _rhsItemName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _lhsItemName.font = _rhsItemName.font = [UIFont fontWithName:@"Arial" size:10.f];
    _lhsItemName.textColor = _rhsItemName.textColor = [UIColor whiteColor];
    _lhsItemName.textAlignment = _rhsItemName.textAlignment = UITextAlignmentCenter;
    [_lhsItemView addSubview:_lhsItemName];
    [_rhsItemView addSubview:_rhsItemName];
    
    _lhsItemTiming = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    _rhsItemTiming = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 100, 40)];
    _lhsItemTiming.font = _rhsItemTiming.font = [UIFont fontWithName:@"Roboto-Condensed" size:16.f];
    [self addSubview:_lhsItemTiming];
    [self addSubview:_rhsItemTiming];
    
    lhsTime = _taSlider.value;
    rhsTime = _taSlider.maximumValue - _taSlider.value;
}

- (void)confirmClicked:(id)sender
{
    [_delegate confirmPressedPassWithLhs:lhsTime Rhs:rhsTime];
}

- (void)cancelClicked:(id)sender
{
    [_delegate cancelPressedPass];
}

- (void)sliderValueChanged:(UISlider*)sender
{

    lhsTime = sender.value;
    rhsTime = sender.maximumValue - sender.value;
    _lhsItemTiming.text = [self getTimeStringBySeconds:lhsTime];
    _rhsItemTiming.text = [self getTimeStringBySeconds:rhsTime];
    NSLog(@"%f + %f",lhsTime,rhsTime);
}

#pragma mark - utilities

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    roundedView.clipsToBounds = YES;
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (NSString *)getTimeStringBySeconds:(double)seconds
{
    NSTimeInterval intervalValue = seconds;
    NSDateFormatter *hmsFormatter = [[NSDateFormatter alloc] init];
    [hmsFormatter setDateFormat:@"HH:mm:ss"];
    [hmsFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [hmsFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:intervalValue]];
}


@end
