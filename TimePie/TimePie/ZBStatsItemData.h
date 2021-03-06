//
//  ZBStatsItemData.h
//  TimePie
//
//  Created by 黄泽彪 on 14-4-13.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBStatsItemData : NSObject

@property (strong,nonatomic) UIColor *mainColor;
@property (strong,nonatomic) NSString *itemName;
@property (strong,nonatomic) NSMutableArray* dataOfMonth;
@property (nonatomic) double currentSecondTime;

- (id)initWithName:(NSString*) name Color:(UIColor *)color MonthData:(NSMutableArray*) array AndSecondTime:(double)currentTime;


- (float)maxValueStartAt:(int)startIndex EndAt:(int)endIndex;
- (float)minValueStartAt:(int)startIndex EndAt:(int)endIndex;
@end
