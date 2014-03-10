//
//  TimePieTableCell.m
//  TimePie
//
//  Created by Storm Max on 14-1-12.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import "TimePieTableCell.h"

@implementation TimePieTableCell
@synthesize colorView;
@synthesize timeLabel;
@synthesize nameLabel;
@synthesize blueBack;
@synthesize clockImage;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
