//
//  timeDistributeCell.m
//  TimePie
//
//  Created by 大畅 on 14-4-2.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "timeDistributeCell.h"
#import "BasicUIColor+UIPosition.h"
#import "tDCPieChart.h"
#import "UIView+Frame.h"

@implementation timeDistributeCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initScrollVessel];
        [self initDistributeGraph];
    }
    return self;
}

- (void)initScrollVessel
{
    _vessel = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 142)];
    _vessel.contentSize = CGSizeMake(SCREEN_WIDTH * 3, _vessel.frame.size.height);
    _vessel.pagingEnabled = YES;
    _vessel.showsHorizontalScrollIndicator = NO;
    [self addSubview:_vessel];
}

- (void)initDistributeGraph
{
    tDCPieChart *testChart1 = [[tDCPieChart alloc] initWithFrame:CGRectMake(10, 10, 100, 130)];
    tDCPieChart *testChart2 = [[tDCPieChart alloc] initWithFrame:CGRectMake(110, 10, 100, 130)];
    tDCPieChart *testChart3 = [[tDCPieChart alloc] initWithFrame:CGRectMake(210, 10, 100, 130)];
    [testChart1 initInfosWithColor:REDNO1 lightColor:RedNO1_light Name:@"学习" Percent:0.7f PercentString:@"70"];
    [testChart2 initInfosWithColor:BLUENO2 lightColor:BLUENO2_light Name:@"酱油" Percent:0.18f PercentString:@"18"];
    [testChart3 initInfosWithColor:GREENNO3 lightColor:GREENNO3_light Name:@"运动" Percent:0.06 PercentString:@"6"];
    [_vessel addSubview:testChart1];
    [_vessel addSubview:testChart2];
    [_vessel addSubview:testChart3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end