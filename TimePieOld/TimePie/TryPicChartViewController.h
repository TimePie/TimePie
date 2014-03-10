//
//  TryPicChartViewController.h
//  TimePie
//
//  Created by Storm Max on 14-1-10.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"


@interface TryPicChartViewController : UIViewController <XYPieChartDataSource,XYPieChartDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet XYPieChart * pieChart;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;


@end
