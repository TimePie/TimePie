//
//  StatsViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsLineGraphView.h"
#import "ZBStatsDataArray.h"
#import "ZBStatsItemData.h"
@interface StatsViewController : UIViewController <StatsLineGraphDelegate,UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (strong,nonatomic) IBOutlet UITableView *itemTableView;

@property (strong, nonatomic) StatsLineGraphView *monthGraph;
@property (strong, nonatomic) StatsLineGraphView *lineGraph;
@property (strong, nonatomic) StatsLineGraphView *daysGraph;

@property(strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;

@property (strong,nonatomic) NSMutableArray *itemDataArray;
@property (strong,nonatomic) NSMutableArray  *colorArray;

@property (strong,nonatomic) NSMutableArray *timingItemArray;
//@property (strong,nonatomic) ZBStatsDataArray* statsItemData;

@end
