//
//  StatsItemTableViewCell.m
//  TimePie
//
//  Created by 黄泽彪 on 14-4-17.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "StatsItemTableViewCell.h"

@implementation StatsItemTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setColorForItem:(UIColor*) color
{
    //
    self.timeLabel.textAlignment=UITextAlignmentRight;
    self.timeLabel.textColor=color;
    
    //create left color block view
    UIView *colorBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4,  self.viewForBaselineLayout.frame.size.height)];
    colorBlock.backgroundColor = color;
    
    [self addSubview:colorBlock];

    
}
@end
