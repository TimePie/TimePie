//
//  tDCPieChart.h
//  TimePie
//
//  Created by 大畅 on 14-4-7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tDCPieChart : UIView
{
    UIColor* _tDCColor;
    UIColor* _tDCLightColor;
    NSString* _tDCEventName;
    CGFloat _tDCPercentage;
    NSString* _tDCPercentageString;
}

- (void)initInfosWithColor:(UIColor*)color lightColor:(UIColor*)lColor Name:(NSString*)eventName Percent:(CGFloat)percent PercentString:(NSString*)pString;

@end
