//
//  ZBStatsDataArray.h
//  TimePie
//
//  Created by 黄泽彪 on 14-4-7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

//store the selected items' name
//and get the info of them

@interface ZBStatsDataArray : NSObject


- (id)initWithCount:(NSInteger) count;
- (void)initAllIntemData;


//@property (strong,nonatomic) NSMutableArray* dataArray;

//
@property (nonatomic) NSInteger itemCount;

@property (strong,nonatomic) NSMutableArray* itemNameList;
@property (strong, nonatomic) NSMutableArray *itemDataArrayList;
@property (strong,nonatomic) NSMutableArray* AllItemData;


@end
