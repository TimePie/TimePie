//
//  PersonalViewAvgTimeCell.m
//  TimePie
//
//  Created by 大畅 on 14-4-2.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "PersonalViewAvgTimeCell.h"
#import "BasicUIColor+UIPosition.h"
#import "TimingItemStore.h"

@implementation PersonalViewAvgTimeCell

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
        [self initTitleImage];
        [self initLabel];
    }
    return self;
}

- (void)initNeededData
{
    storeManager = [[TimingItemStore alloc] init];
    dayCount = [NSNumber numberWithInt:7];
}

- (void)initTitleImage
{
    _titleImageTotal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalView_Total"]];
    _titleImageTotal.frame = CGRectMake(15, 20, 41, 15);
    [self addSubview:_titleImageTotal];
    
    _titleImageAvg = [[UIImageView alloc] initWithImage:[UIImage
                                                         imageNamed:@"PersonalView_Avg"]];
    _titleImageAvg.frame = CGRectMake(190, 20, 41, 15);
    [self addSubview:_titleImageAvg];
}

- (void)initLabel
{
    _labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 160, 40)];
    _labelTotal.font = [UIFont fontWithName:@"Roboto-Medium" size:30.f];
    _labelTotal.textColor = MAIN_UI_COLOR;
    [self addSubview:_labelTotal];
    [self.delegate showTotalTime];
    
    UILabel* hourIndicator1 = [[UILabel alloc] initWithFrame:CGRectMake(108, 20, 40, 20)];
    hourIndicator1.text = @"h";
    hourIndicator1.font = [UIFont fontWithName:@"Roboto-Medium" size:14.f];
    hourIndicator1.textColor = MAIN_UI_COLOR;
    [self addSubview:hourIndicator1];
    UILabel* hourIndicator2 = [[UILabel alloc] initWithFrame:CGRectMake(283, 20, 40, 20)];
    hourIndicator2.text = @"h";
    hourIndicator2.font = [UIFont fontWithName:@"Roboto-Medium" size:14.f];
    hourIndicator2.textColor = MAIN_UI_COLOR;
    [self addSubview:hourIndicator2];
    
    _labelAvg = [[UILabel alloc] initWithFrame:CGRectMake(245, 5, 160, 40)];
    _labelAvg.font = [UIFont fontWithName:@"Roboto-Medium" size:30.f];
    _labelAvg.textColor = MAIN_UI_COLOR;
    [self addSubview:_labelAvg];
    [self.delegate showAvgTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadText
{
    _labelTotal.text = [NSString stringWithFormat:@"%@",dayCount];
    _labelAvg.text = [NSString stringWithFormat:@"%@",dayCount];
}

- (void)reloadDayCount:(NSInteger)dCount
{
    dayCount = [NSNumber numberWithInt:dCount];
    [self loadText];
}


@end
