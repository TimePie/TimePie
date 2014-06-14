//
//  MainScreenViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "TimingItemStore.h"
#import "MainScreenTableView.h"
#import "SelectView.h"
#import "TCell.h"
//#import "WXApi.h"
//#import "WXApiObject.h"

@class BounceAnimation;

@interface MainScreenViewController : UIViewController <XYPieChartDataSource,XYPieChartDelegate, UITableViewDelegate, UITableViewDataSource,UIViewControllerTransitioningDelegate,SWTableViewCellDelegate>
{
//    IBOutlet UIButton *stats;
    IBOutlet UIButton *historyBtn;
    IBOutlet UIButton *cancelBtn;
    IBOutlet UIButton *shareBtn;
    
    
    NSMutableArray * selectedArray;
    UIButton *personalButton;
    UIBarButtonItem *addItemButton;
    XYPieChart *pieChart;
    TimingItemStore * timingItemStore;
    MainScreenTableView *itemTable;
    NSTimer * timer;
    BOOL selectMode;
    UITapGestureRecognizer *tapRecognizer;
    UILabel *titleDateView;
    UILabel *titleOriginalView;
    
    int count;
    
    SelectView * selectView;
    
    
}

@property (nonatomic, strong) BounceAnimation *mAnimation;

- (IBAction)stats_btn_clicked:(id)sender;



@end
