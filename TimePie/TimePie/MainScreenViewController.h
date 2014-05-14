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

@interface MainScreenViewController : UIViewController <XYPieChartDataSource,XYPieChartDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *stats;
    
    XYPieChart *pieChart;
    TimingItemStore * timingItemStore;
    MainScreenTableView *itemTable;
    NSTimer * timer;
    
    
    
    SelectView * selectView;
    
    
}



- (IBAction)stats_btn_clicked:(id)sender;



@end
