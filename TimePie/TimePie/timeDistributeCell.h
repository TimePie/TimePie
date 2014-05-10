//
//  timeDistributeCell.h
//  TimePie
//
//  Created by 大畅 on 14-4-2.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeDistributeCell : UITableViewCell<UIScrollViewDelegate>
{
    NSArray *tagList;
}
@property (strong, nonatomic) UIScrollView *vessel;

@end
