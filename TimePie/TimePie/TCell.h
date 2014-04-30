//
//  TCell.h
//  TimePie
//
//  Created by Max Lu on 4/30/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCell : UITableViewCell


@property(nonatomic, strong) IBOutlet UILabel * itemName;
@property(nonatomic, strong) IBOutlet UILabel * itemTime;
@property(nonatomic, strong) IBOutlet UIImageView * itemColor;
@property(nonatomic, strong) IBOutlet UIImageView * itemNotice;



@end
