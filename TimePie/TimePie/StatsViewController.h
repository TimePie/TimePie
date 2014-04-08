//
//  StatsViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "ZBStatsDataArray.h"

@interface StatsViewController : UIViewController <BEMSimpleLineGraphDelegate> 

@property (strong, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;

@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;


@property (strong,nonatomic) ZBStatsDataArray* statsItemData;

@end
