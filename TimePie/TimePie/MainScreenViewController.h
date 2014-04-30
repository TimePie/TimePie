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

@interface MainScreenViewController : UIViewController <XYPieChartDataSource,XYPieChartDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *stats;
    
    XYPieChart *pieChart;
    TimingItemStore * timingItemStore;
    UITableView *itemTable;
    
}



- (IBAction)stats_btn_clicked:(id)sender;

@property(nonatomic, strong) NSArray *sliceColors;
@property(nonatomic, strong) NSMutableArray *slices;




@end
