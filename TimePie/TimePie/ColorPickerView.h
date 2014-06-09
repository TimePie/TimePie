//
//  ColorPickerView.h
//  TimePie
//
//  Created by 大畅 on 14/6/7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerViewDelegate <NSObject>

@required
- (void)sendChosenColorWithColor:(UIColor*)chosenItemColor ColorTag:(int)chosenColorTag;

@end

@interface ColorPickerView : UIView

@property (nonatomic, strong) UIScrollView *CPV_mainVessel;
@property (nonatomic, assign) id<ColorPickerViewDelegate> delegate;

@end
