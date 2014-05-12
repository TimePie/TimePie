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

#import "TimingItemStore.h"
#import "Tag.h"

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
        [self initNeededData];
        [self initScrollVessel];
        [self initDistributeGraph];
    }
    return self;
}

- (void)initNeededData
{
    tagList = [[TimingItemStore timingItemStore] getAllTags];
    colorList = [NSMutableArray arrayWithObjects:REDNO1,BLUENO2,GREENNO3,PINKNO04,BROWNN05,YELLOWN06, PURPLEN07, P01N08, P01N09, P01N10, nil];
    lightColorList = [NSMutableArray arrayWithObjects:RedNO1_light, BLUENO2_light, GREENNO3_light, PINKNO04_light, BROWNN05_light, YELLOWN06_light, PURPLEN07_light, P01N08_light, P01N09_light, P01N10_light, nil];
    totalTime = [[TimingItemStore timingItemStore] getTotalDays];
    timeOfEachTag = [[NSMutableArray alloc] init];
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
    if (tagList.count > 0)
    {
//        for (int i = 0; i < tagList.count; i++)
//        {
//            [timeOfEachTag addObject:[[TimingItemStore timingItemStore] getDailyTimeByTagName:[tagList objectAtIndex:i] date:[NSDate date]]];
//            tDCPieChart *tempChart =[[tDCPieChart alloc] initWithFrame:CGRectMake(10 + 100 * i, 10, 100, 130)];
//            [tempChart initInfosWithColor:[colorList objectAtIndex:i] lightColor:[lightColorList objectAtIndex:i] Name:[NSString stringWithFormat:@"%@",(Tag*)[[tagList objectAtIndex:i] tag_name]] Percent:0.7f PercentString:@"70"];
//            [_vessel addSubview:tempChart];
//        }
        tDCPieChart *testChart1 = [[tDCPieChart alloc] initWithFrame:CGRectMake(10, 10, 100, 130)];
        tDCPieChart *testChart2 = [[tDCPieChart alloc] initWithFrame:CGRectMake(110, 10, 100, 130)];
        tDCPieChart *testChart3 = [[tDCPieChart alloc] initWithFrame:CGRectMake(210, 10, 100, 130)];
        [testChart1 initInfosWithColor:REDNO1 lightColor:RedNO1_light Name:[NSString stringWithFormat:@"%@",(Tag*)[[tagList objectAtIndex:0] tag_name]] Percent:0.7f PercentString:@"70"];
        [testChart2 initInfosWithColor:BLUENO2 lightColor:BLUENO2_light Name:[NSString stringWithFormat:@"%@",(Tag*)[[tagList objectAtIndex:1] tag_name]] Percent:0.18f PercentString:@"18"];
        [testChart3 initInfosWithColor:GREENNO3 lightColor:GREENNO3_light Name:@"运动" Percent:0.06 PercentString:@"6"];
        [_vessel addSubview:testChart1];
        [_vessel addSubview:testChart2];
        [_vessel addSubview:testChart3];
    }
    else NSLog(@"Create new items to view history stats");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
