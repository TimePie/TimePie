//
//  StatsItemTableViewCell.h
//  TimePie
//
//  Created by 黄泽彪 on 14-4-17.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsItemTableViewCell : UITableViewCell


@property (strong,nonatomic) IBOutlet UILabel *timeLabel;
@property (strong,nonatomic) IBOutlet UILabel *itemName;
@property (strong,nonatomic) UIColor* itemColor;

- (void) setColorForItem:(UIColor*) color;

@end
