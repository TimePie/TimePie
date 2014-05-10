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


@interface MainScreenViewController : UIViewController <XYPieChartDataSource,XYPieChartDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *stats;
    
    XYPieChart *pieChart;
    TimingItemStore * timingItemStore;
    MainScreenTableView *itemTable;
    NSTimer * timer;
    
    
    
    UIView * selectView;
    UIButton * viewHistory;
    UIButton * cancelSelect;
    
}



- (IBAction)stats_btn_clicked:(id)sender;



@end
