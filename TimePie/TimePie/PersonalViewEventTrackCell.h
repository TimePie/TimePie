//
//  PersonalViewEventTrackCell.h
//  TimePie
//
//  Created by 大畅 on 14-4-7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalViewEventTrackCell : UITableViewCell
{
    NSMutableArray *eventTrackColumnHeightArray;
}
@property (strong, nonatomic) UILabel *PVETCEventLabel;
@property (strong, nonatomic) UILabel *PVETCAvgTimeLabel;
@property (strong, nonatomic) UILabel *PVETCHourIndicatorLabel;
@property (strong, nonatomic) UIColor *cellColor;

- (void)initCellWithColor:(UIColor*)cColor ColumnCount:(NSInteger)cCount HeightArray:(NSMutableArray*)cHeightArray;

@end
