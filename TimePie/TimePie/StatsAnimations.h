//
//  StatsAnimations.h
//  TimePie
//
//  Created by 黄泽彪 on 14-4-24.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsCircle.h"
#import "StatsLine.h"

@protocol StatsAnimationsDelegate <NSObject>

@end

@interface StatsAnimations : NSObject

/// Class for the animation when the graph first gets created.
- (void)animationForDot:(NSInteger)dotIndex circleDot:(StatsCircle *)circleDot animationSpeed:(NSInteger)speed;
- (void)animationForLine:(NSInteger)lineIndex line:(StatsLine *)line animationSpeed:(NSInteger)speed;

@property (assign) id <StatsAnimationsDelegate> delegate;


@end
