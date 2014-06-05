//
//  RingCircle.h
//  TimePie
//
//  Created by Max Lu on 6/5/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RingCircle : UIView
{
    UIView * circleView;
    UIView * ringView;
    float radius;
    float innerRadius;
}



- (id)initWithFrame:(CGRect)frame
     withPercentage:(float)percentage
          withColor:(UIColor*)color;
@end
