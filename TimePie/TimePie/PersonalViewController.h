//
//  PersonalViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@class PersonalViewPicker;
@interface PersonalViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SettingsViewControllerDelegate>
{
    UIView *darkUILayer;
    NSString *timeRangeInfo;
    
    NSMutableArray *tagList;
    NSMutableArray *trackedTagList;
    NSArray *colorList;
    NSArray *lightColorList;
    
    NSMutableArray *columnHeightList;
    NSMutableArray *avgTimeOfTagList;
}

@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UIButton *exitButton;

@property (strong, nonatomic) UITableView *mainView;
@property (strong, nonatomic) PersonalViewPicker *pVCPicker;

@end
