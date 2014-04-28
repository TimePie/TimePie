//
//  TimePieTableViewCell.h
//  TimePie
//
//  Created by Max Lu on 4/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePieTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *itemName;
@property (nonatomic, weak) IBOutlet UILabel *itemTime;
@property (nonatomic, weak) IBOutlet UIView *itemColor;
@property (nonatomic, weak) IBOutlet UIImageView *itemNotice;



@end
