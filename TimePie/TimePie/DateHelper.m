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

    
    //final version
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    
    
    //test version
    //NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    
    return [calendar dateFromComponents:components];
}

+ (NSDate *)endOfDay:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [NSDateComponents new];
    
    //final version
    components.day = 1;
    
    //test version
    //components.minute = 1;
    
    NSDate *date1 = [calendar dateByAddingComponents:components toDate:[DateHelper beginningOfDay:date]  options:0];
    
    date1 = [date1 dateByAddingTimeInterval:-1];
    
    return date1;
}

+(BOOL)checkAcrossDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate * now = [NSDate date];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
//    NSLog(@"%d",components.second);
    
    
    /*
    if(components.second==0){
        return true;
    }
     */
    
    
    
    if (components.hour==0&&components.minute==0&&components.second==0)
    {
        return true;
    }

    
    return false;
}


+(BOOL)checkIf5760
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate * now = [NSDate date];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
    NSInteger temp  = components.second;
    temp%=15;
    if(temp>=0&&temp<=4)
    {
        return true;
    }
    
    
    return false;
}

+(BOOL)checkIf123
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate * now = [NSDate date];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
    NSInteger temp  = components.second;
    temp%=10;
    if(temp>=6&&temp<=9)
    {
        return true;
    }
    
    
    return false;
}



+(NSString*)getDateString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate * now = [NSDate date];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
    
    
    return [NSString stringWithFormat:@"%ld.%ld.%ld",(long)components.year, (long)components.month, (long)components.day];
}


+(NSString*)getDateString:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate * now = date;
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
    
    
    return [NSString stringWithFormat:@"%ld.%ld.%ld",(long)components.year, (long)components.month, (long)components.day];
    
}

+(NSDate *)getYesterday:(NSDate*)now
{
    int daysToAdd = -1;
    
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setDay:daysToAdd];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    
    NSDate *yesterday = [gregorian dateByAddingComponents:components toDate:now options:0];
//    NSLog(@"Yesterday: %@", yesterday);
    
    return yesterday;
}

+(NSDate *)getTomorrow:(NSDate*)now
{
    int daysToAdd = 1;
    
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setDay:daysToAdd];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    
    NSDate *tomorrow = [gregorian dateByAddingComponents:components toDate:now options:0];
//    NSLog(@"tomorrow: %@", tomorrow);
    
    return tomorrow;
}

@end
