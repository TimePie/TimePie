//
//  SettingsViewController.h
//  TimePie
//
//  Created by 大畅 on 14-4-20.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate <NSObject>

@required
- (void)reverseCloseButton;

@end

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) UINavigationBar *navBar;
@property (nonatomic, assign) id<SettingsViewControllerDelegate> delegate;

@end
