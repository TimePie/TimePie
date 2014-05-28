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

@class BounceAnimation;

@interface MainScreenViewController : UIViewController <XYPieChartDataSource,XYPieChartDelegate, UITableViewDelegate, UITableViewDataSource,UIViewControllerTransitioningDelegate>
{
//    IBOutlet UIButton *stats;
    IBOutlet UIButton *historyBtn;
    IBOutlet UIButton *cancelBtn;
    
    
    
    NSMutableArray * selectedArray;
    XYPieChart *pieChart;
    TimingItemStore * timingItemStore;
    MainScreenTableView *itemTable;
    NSTimer * timer;
    BOOL selectMode;
    
    
    int count;
    
    SelectView * selectView;
    
    
}

@property (nonatomic, strong) BounceAnimation *mAnimation;

- (IBAction)stats_btn_clicked:(id)sender;



@end
