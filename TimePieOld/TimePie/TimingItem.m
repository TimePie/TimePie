//
//  TimingItem.m
//  TimePie
//
//  Created by Storm Max on 14-1-9.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import "TimingItem.h"

@implementation TimingItem

@synthesize itemName;
@synthesize dateCreated;
@synthesize time;
@synthesize startDate;
@synthesize oldTime;
@synthesize color;


+ (id)randomItem{
    return [[self alloc] initWithItemName:@"aTimeItem"];
}

- (id)initWithItemName:(NSString *)name
{
    self = [super init];
    if (self) {
        [self setItemName:name];
        [self setTime:0];
        [self setOldTime:0];
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


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setTime:[aDecoder decodeDoubleForKey:@"time"]];
        [self setOldTime:[aDecoder decodeDoubleForKey:@"oldTime"]];
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        [self setStartDate:[aDecoder decodeObjectForKey:@"startDate"]];
        
        [self setColor:[aDecoder decodeObjectForKey:@"color"]];
    }
    return self;
}

/*
 refreshStartTime: set oldTime = time;
 set startDate = current time
 if(compensate): time += slepted(app closed) time
 else: do nothing.
*/


- (void)refreshStartTime:(BOOL)compensate{
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    if (compensate) {
        double intervalTime = [localeDate timeIntervalSinceReferenceDate]-[[self startDate] timeIntervalSinceReferenceDate];
        [self setTime:oldTime + intervalTime];
    }
    startDate =localeDate;
    self.oldTime=time;
}



/////****need fix!!!
- (NSString *)description
{
    NSInteger dateTime = time - 60*60*8;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:dateTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@: %@",itemName,dateString];
    return descriptionString;
}


- (NSString *)getTimeString{
    NSInteger dateTime = time - 60*60*8;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:dateTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeDouble:time forKey:@"time"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:startDate forKey:@"startDate"];
    [aCoder encodeDouble:oldTime forKey:@"oldTime"];
    [aCoder encodeObject:color forKey:@"color"];
}


@end
