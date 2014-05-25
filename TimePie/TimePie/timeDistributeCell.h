//
//  timeDistributeCell.h
//  TimePie
//
//  Created by 大畅 on 14-4-2.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tDCPieChart;
@interface timeDistributeCell : UITableViewCell<UIScrollViewDelegate>
{
    NSArray *tagList;
    NSArray *colorList;
    NSArray *lightColorList;
    NSNumber *totalTime;
    NSMutableArray *timeOfEachTag;
    NSMutableArray *tDCPieChartList;
}
@property (strong, nonatomic) UIScrollView *vessel;

- (void)reloadTotalHours:(NSNumber*)tHours;

@end
