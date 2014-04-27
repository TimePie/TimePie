//
//  ZBStatsItemData.m
//  TimePie
//
//  Created by 黄泽彪 on 14-4-13.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "ZBStatsItemData.h"

@implementation ZBStatsItemData

- (id)initWithName:(NSString *)name Color:(UIColor *)color AndMouthData:(NSMutableArray*) array
{
    if ((self = [super init]))
    {
        self.itemName=name;
        self.mainColor=color;
        self.dataOfMonth=array;
    }
    return self;
}


- (float)maxValueStartAt:(int)startIndex EndAt:(int)endIndex
{
    float dotValue;
    float maxValue = 0;
    
    for (int i = startIndex; i < endIndex||i<self.dataOfMonth.count; i++) {
        dotValue = [[self.dataOfMonth objectAtIndex:i] floatValue ];
        
        if (dotValue > maxValue) {
            maxValue = dotValue;
        }
    }
    
    return maxValue;
}
- (float)minValueStartAt:(int)startIndex EndAt:(int)endIndex
{
    float dotValue;
    float minValue = INFINITY;
    
    for (int i = startIndex; i < endIndex||i<self.dataOfMonth.count; i++) {
        dotValue = [[self.dataOfMonth objectAtIndex:i] floatValue ];
        
        if (dotValue < minValue) {
            minValue = dotValue;
        }
    }
    
    return minValue;
}


@end
