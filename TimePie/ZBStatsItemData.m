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





@end
