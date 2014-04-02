//
//  PersonalViewAvgTimeCell.m
//  TimePie
//
//  Created by 大畅 on 14-4-2.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "PersonalViewAvgTimeCell.h"
#import "BasicUIColor+UIPosition.h"

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
        [self initTitleImage];
        [self initLabel];
    }
    return self;
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
    _labelTotal.text = @"99";
    _labelTotal.font = [UIFont fontWithName:@"Roboto-Medium" size:30.f];
    _labelTotal.textColor = MAIN_UI_COLOR;
    [self addSubview:_labelTotal];
    [self.delegate showTotalTime];
    
    _labelAvg = [[UILabel alloc] initWithFrame:CGRectMake(245, 5, 160, 40)];
    _labelAvg.text = @"99";
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

@end
