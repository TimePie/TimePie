//
//  TPMainViewController.h
//  TimePie
//
//  Created by Storm Max on 14-1-9.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "InfColorPickerController.h"

@interface TPMainViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,InfColorPickerControllerDelegate>
{
    NSTimer * timer;
    BOOL *timing;
    XYPieChart *pieChart;
    BOOL editingMode;
}
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@end
