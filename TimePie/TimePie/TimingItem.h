//
//  TimingItem.h
//  TimePie
//
//  Created by Storm Max on 4/16/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimingItem : NSObject


+ (id)randomItem;
- (id)initWithItemName:(NSString *)name;


@property (nonatomic, strong) NSString * itemName;
@property (nonatomic, readonly, strong) NSDate * dateCreated;
@property (nonatomic) double time;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) UIColor * color;

@end
