//
//  SocialShareViewController.h
//  TimePie
//
//  Created by 大畅 on 14-5-31.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "WeiboViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "XYPieChart.h"
#import "TimingItemStore.h"

@interface SocialShareViewController : UIViewController<WBHttpRequestDelegate,XYPieChartDataSource,XYPieChartDelegate,UIViewControllerTransitioningDelegate>
{
    NSMutableArray *itemList;
    XYPieChart * pieChart;
    TimingItemStore * timingItemStore;
    NSTimer * timer;
    UIScrollView * scroll;
    UIView * contentView;
}
@property (nonatomic, strong) UIImageView *pieChartImage;
@property (retain, nonatomic) WeiboViewController* WeiboviewController;

@end
