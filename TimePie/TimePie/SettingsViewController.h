//
//  SettingsViewController.h
//  TimePie
//
//  Created by 大畅 on 14-4-20.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackItemViewController.h"

@protocol SettingsViewControllerDelegate <NSObject>

@required
- (void)reverseCloseButton;
- (void)reloadSecondPass;

@end

@interface SettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,TrackItemViewDelegate>

@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UITableView *SVCVessel;
@property (strong, nonatomic) NSMutableArray *themeColors;
@property (nonatomic, assign) id<SettingsViewControllerDelegate> delegate;

@end
