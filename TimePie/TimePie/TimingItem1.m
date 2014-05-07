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
@synthesize lastCheck;
@synthesize active;
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
        lastCheck =localeDate;
        active = NO;
        [self setColor:0];
    }
    return self;
}


- (NSDate*) check:(BOOL)add
{
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
//    NSLog([NSString stringWithFormat:@"check item:%@", itemName]);
//    NSLog([NSString stringWithFormat:@"lask check:%@", lastCheck]);
//    NSLog([NSString stringWithFormat:@"lask check:%@", localeDate]);
    
    if(add){
        double timeInterval = [localeDate timeIntervalSinceReferenceDate]-[lastCheck timeIntervalSinceReferenceDate];
        time+=timeInterval;
//        NSLog([NSString stringWithFormat:@"interval: %f", timeInterval]);
    }
    lastCheck = localeDate;
    

    
    return localeDate;
}

- (NSString *)getTimeString
{
    NSInteger dateTime = time - 60*60*8;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:dateTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}



@end
