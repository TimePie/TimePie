//
//  timeDistributeCell.m
//  TimePie
//
//  Created by 大畅 on 14-4-2.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "timeDistributeCell.h"
#import "BasicUIColor+UIPosition.h"

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
    _vessel = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    _vessel.contentSize = CGSizeMake(900, _vessel.frame.size.height);
    [self addSubview:_vessel];
}

- (void)initDistributeGraph
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
