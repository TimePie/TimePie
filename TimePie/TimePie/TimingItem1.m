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
@synthesize color;
@synthesize timing;
@synthesize tracking;



+ (id)randomItem{
    return [[self alloc] initWithItemName:@"An item"];
}

- (id) initWithItemName:(NSString *)name
{
    self = [super init];
    if(self){
        [self setItemName:name];
//        [self setTime:0];
        time = 0;
        dateCreated = [[NSDate alloc] init];
        NSDate *adate = [NSDate date];
        lastCheck =adate;
        timing = NO;
        tracking = NO;
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
//    NSLog([NSString stringWithFormat:@"check:%@", adate]);
//    NSLog([NSString stringWithFormat:@"lask check:%@", lastCheck]);
    
    
    
    
    if(add){
        double timeInterval = [adate timeIntervalSinceDate:lastCheck];
        time+=timeInterval;
    }
    lastCheck = adate;
    

    
    return adate;
}

- (NSString *)getTimeString
{
    
    
    NSTimeInterval intervalValue = time;
    NSDateFormatter *hmsFormatter = [[NSDateFormatter alloc] init];
    [hmsFormatter setDateFormat:@"HH:mm:ss"];
    [hmsFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    NSLog(@"formatted date: %@", [hmsFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:intervalValue]]);
    
    return [hmsFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:intervalValue]];

}



@end
