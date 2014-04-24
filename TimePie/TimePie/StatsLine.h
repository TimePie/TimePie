//
//  StatsLine.h
//  TimePie
//
//  Created by 黄泽彪 on 14-4-24.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsLine : UIView

@property (assign, nonatomic) CGPoint  firstPoint;
@property (assign, nonatomic) CGPoint  secondPoint;

// COLORS
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *topColor;
@property (strong, nonatomic) UIColor *bottomColor;


// ALPHA
@property (nonatomic) float topAlpha;
@property (nonatomic) float bottomAlpha;
@property (nonatomic) float lineAlpha;

@property (nonatomic) float lineWidth;


@end
