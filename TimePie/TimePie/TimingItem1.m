//
//  TimingItem.m
//  TimePie
//
//  Created by Storm Max on 4/16/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "TimingItem1.h"

@implementation TimingItem


@synthesize itemName;
@synthesize dateCreated;
@synthesize time;
@synthesize startDate;
@synthesize color;




+ (id)randomItem{
    return [[self alloc] initWithItemName:@"An item"];
}

- (id) initWithItemName:(NSString *)name
{
    self = [super init];
    if(self){
        [self setItemName:name];
        [self setTime:0];
        dateCreated = [[NSDate alloc] init];
        NSDate *adate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: adate];
        NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
        startDate =localeDate;
        [self setColor:[UIColor blackColor]];
    }
    return self;
}



@end
