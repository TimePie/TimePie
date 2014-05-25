//
//  PersonalViewAvgTimeCell.h
//  TimePie
//
//  Created by 大畅 on 14-4-2.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimingItemStore;

@protocol PersonalViewAvgTimeProtocal <NSObject>

@required
- (void)showTotalTime;
- (void)showAvgTime;

@end

@interface PersonalViewAvgTimeCell : UITableViewCell
{
    TimingItemStore *storeManager;
    NSNumber *dayCount;
    NSNumber *totalHours;
}
@property (strong, nonatomic) UIImageView *titleImageTotal;
@property (strong, nonatomic) UIImageView *titleImageAvg;

@property (strong, nonatomic) UILabel *labelTotal;
@property (strong, nonatomic) UILabel *labelAvg;

@property (nonatomic, assign) id<PersonalViewAvgTimeProtocal> delegate;

- (void)reloadDayCount:(NSInteger)dCount;
- (void)reloadTotalHours:(NSNumber*)tHours;

@end
