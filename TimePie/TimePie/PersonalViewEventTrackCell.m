//
//  PersonalViewEventTrackCell.m
//  TimePie
//
//  Created by 大畅 on 14-4-7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "PersonalViewEventTrackCell.h"
#import "BasicUIColor+UIPosition.h"
#import "eventTrackColumnGraph.h"

#define COLUMN_GRAPH_START_COUNT 700

@implementation PersonalViewEventTrackCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initlabel];
    }
    return self;
}

- (void)initlabel
{
    _PVETCEventLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, 100, 20)];
    _PVETCEventLabel.text = @"学习";
    _PVETCEventLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.f];
    _PVETCEventLabel.textColor = REDNO1;
    [self addSubview:_PVETCEventLabel];
    
    _PVETCAvgTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 15, 40, 20)];
    _PVETCAvgTimeLabel.text = @"7.8";
    _PVETCAvgTimeLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:25.f];
    _PVETCAvgTimeLabel.textColor = REDNO1;
    [self addSubview:_PVETCAvgTimeLabel];
    
    _PVETCHourIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_PVETCAvgTimeLabel.frame.origin.x + _PVETCAvgTimeLabel.frame.size.width - 2, 23, 20, 10)];
    _PVETCHourIndicatorLabel.text = @"h";
    _PVETCHourIndicatorLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14.f];
    _PVETCHourIndicatorLabel.textColor = REDNO1;
    [self addSubview:_PVETCHourIndicatorLabel];
}

- (void)initEventTrackColumnGraphWithColumnCount:(NSInteger)cCount HeightArray:(NSMutableArray *)cHeightArray
{
    if ([self viewWithTag:COLUMN_GRAPH_START_COUNT])
        [[self viewWithTag:COLUMN_GRAPH_START_COUNT] removeFromSuperview];
    NSArray *tempCHeightArray = @[@15.f,@20.f,@15.f,@20.f,@15.f,@20.f];
    eventTrackColumnHeightArray = [NSMutableArray arrayWithArray:tempCHeightArray];
    eventTrackColumnGraph *columnGraph = [[eventTrackColumnGraph alloc] initWithFrame:CGRectMake(0, 10, 250, 40)];
    columnGraph.tag = COLUMN_GRAPH_START_COUNT;
    [columnGraph initColumnGraphWithColumnCount:cCount heightArray:cHeightArray columnColor:_cellColor];
    [self addSubview:columnGraph];
}

- (void)initCellWithColor:(UIColor *)cColor ColumnCount:(NSInteger)cCount HeightArray:(NSMutableArray *)cHeightArray
{
    _cellColor = cColor;
    [self initEventTrackColumnGraphWithColumnCount:cCount HeightArray:cHeightArray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
