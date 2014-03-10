//
//  TimePieTableCell.h
//  TimePie
//
//  Created by Storm Max on 14-1-12.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePieTableCell : UITableViewCell

@property (nonatomic) IBOutlet UIView * colorView;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) IBOutlet UIImageView *blueBack;
@property (nonatomic) IBOutlet UIImageView *clockImage;
@end
