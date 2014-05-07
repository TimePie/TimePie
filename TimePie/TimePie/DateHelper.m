//
//  DateHelper.m
//  TimePie
//
//  Created by Max Lu on 5/7/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper



+ (NSDate *)beginningOfDay:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:date];
    
    return [calendar dateFromComponents:components];
}

+ (NSDate *)endOfDay:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    
    NSDate *date1 = [calendar dateByAddingComponents:components
                                             toDate:[DateHelper beginningOfDay:date]
                                            options:0];
    
    date1 = [date1 dateByAddingTimeInterval:-1];
    
    return date1;
}


@end
