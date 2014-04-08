//
//  ZBStatsDataArray.m
//  TimePie
//
//  Created by 黄泽彪 on 14-4-7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "ZBStatsDataArray.h"

@implementation ZBStatsDataArray

- (id)initWithCount:(NSInteger) count
{
    if ((self = [super init]))
    {
        self.itemNameList=[[NSMutableArray alloc]init];
        self.itemCount =count;
        self.itemDataArrayList =[[NSMutableArray alloc]init];
        //[self.dataArray initWithArray:data];
    }
    return self;
}

-(void)initAllIntemData
{
    self.AllItemData=[[NSMutableArray alloc] init];
    for(int i= 0;i<self.itemDataArrayList.count;i++)
    {
        [self.AllItemData addObjectsFromArray:[self.itemDataArrayList objectAtIndex:i]];
    }
}



@end
