//
//  eventTrackColumnGraph.h
//  TimePie
//
//  Created by 大畅 on 14-4-15.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventTrackColumnGraph : UIView
{
    NSInteger columnCount;
    NSMutableArray *columnHeightArray;
    UIColor *columnColor;
}

- (void)initColumnGraphWithColumnCount:(NSInteger)cCount heightArray:(NSMutableArray*)cHeightArray columnColor:(UIColor*)cColor;

@end
