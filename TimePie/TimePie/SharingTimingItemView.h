//
//  SharingTimingItemView.h
//  TimePie
//
//  Created by Max Lu on 6/5/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingCircle.h"
#import "TimingItem1.h";

@interface SharingTimingItemView : UIView
{
    RingCircle * ringCircle;
}



- (id)initWithFrame:(CGRect)frame
           withItem:(TimingItem*)item;
@end
