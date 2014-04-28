//
//  TimePieTableViewCell.m
//  TimePie
//
//  Created by Max Lu on 4/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "TimePieTableViewCell.h"

@implementation TimePieTableViewCell

@synthesize itemName;
@synthesize itemColor;
@synthesize itemNotice;
@synthesize itemTime;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
