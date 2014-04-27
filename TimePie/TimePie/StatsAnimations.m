//
//  StatsAnimations.m
//  TimePie
//
//  Created by 黄泽彪 on 14-4-24.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

@import Foundation;
#import "StatsAnimations.h"

@implementation StatsAnimations


// Animation of the dots
- (void)animationForDot:(NSInteger)dotIndex circleDot:(StatsCircle *)circleDot animationSpeed:(NSInteger)speed {
    if (speed == 0) {
        circleDot.alpha = 0;
    } else {
        [UIView animateWithDuration:0.5 delay:dotIndex/(speed*2.0) options:UIViewAnimationOptionCurveEaseOut animations:^{
            circleDot.alpha = 0.7;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                circleDot.alpha = 0;
            } completion:nil];
        }];
    }
}

// Animation of the graph
- (void)animationForLine:(NSInteger)lineIndex line:(StatsLine *)line animationSpeed:(NSInteger)speed {
    if (speed == 0) {
        line.alpha = 1.0;
    } else {
        [UIView animateWithDuration:1.0 delay:lineIndex/(speed*2.0) options:UIViewAnimationOptionCurveEaseOut animations:^{
            line.alpha = 1.0;
        } completion:nil];
    }
}


@end
