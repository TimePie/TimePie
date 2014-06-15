//
//  TimeAdjustView.h
//  TimePie
//
//  Created by 大畅 on 14/6/14.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimingItem;
@protocol TimeAdjustViewDelegate <NSObject>

- (void)cancelPressedPass;
- (void)confirmPressedPassWithLhs:(double)lTime Rhs:(double)rTime;

@end

@interface TimeAdjustView : UIView
{
    double lhsTime;
    double rhsTime;
}
/**
 *  left adjust item
 */
@property (nonatomic, strong) UIView *lhsItemView;
/**
 *  right adjust item
 */
@property (nonatomic, strong) UIView *rhsItemView;
/**
 *  left item Name
 */
@property (nonatomic, strong) UILabel *lhsItemName;
/**
 *  right item Name
 */
@property (nonatomic, strong) UILabel *rhsItemName;
/**
 *  left item Time
 */
@property (nonatomic, strong) UILabel *lhsItemTiming;
/**
 *  right item Time
 */
@property (nonatomic, strong) UILabel *rhsItemTiming;

@property (nonatomic, strong) TimingItem *lhsItem;
@property (nonatomic, strong) TimingItem *rhsItem;

@property double lhsOriginalTime;
@property double rhsOriginalTime;

@property (nonatomic, strong) UISlider *taSlider;

@property (nonatomic, assign) id<TimeAdjustViewDelegate> delegate;

@end
