//
//  MainScreenViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface MainScreenViewController : UIViewController <XYPieChartDataSource,XYPieChartDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *personal;
    IBOutlet UIButton *stats;
    IBOutlet UIButton *create;
    XYPieChart *pieChart;
    UITableView *itemTable;
    NSArray *items;
}



- (IBAction)personal_btn_clicked:(id)sender;
- (IBAction)stats_btn_clicked:(id)sender;
- (IBAction)create_btn_clicked:(id)sender;

@property(nonatomic, strong) NSArray *sliceColors;
@property(nonatomic, strong) NSMutableArray *slices;




@end
