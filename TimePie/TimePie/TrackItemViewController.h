//
//  TrackItemViewController.h
//  TimePie
//
//  Created by 大畅 on 14-5-12.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrackItemViewDelegate <NSObject>

- (void)reloadPass;

@end

@interface TrackItemViewController : UIViewController

@property (nonatomic, assign) id<TrackItemViewDelegate> delegate;

@end
