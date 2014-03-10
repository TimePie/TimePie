//
//  TimingItem.h
//  TimePie
//
//  Created by Storm Max on 14-1-9.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimingItem : NSObject<NSCoding>


+ (id)randomItem;
- (id)initWithItemName:(NSString *)name;
- (void)refreshStartTime:(BOOL)compensate;
- (NSString *)getTimeString;
@property (nonatomic, strong) NSString * itemName;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic) double time;
@property (nonatomic) double oldTime;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) UIColor * color;


@end
