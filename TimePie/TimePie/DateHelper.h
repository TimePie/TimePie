//
//  DateHelper.h
//  TimePie
//
//  Created by Max Lu on 5/7/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+(NSDate *)beginningOfDay:(NSDate *)date;
+(NSDate *)endOfDay:(NSDate *)date;
+(BOOL)checkAcrossDay;
+(BOOL)checkIf5760;
+(BOOL)checkIf123;
+(NSString*)getDateString;
+(NSString*)getDateString:(NSDate*)date;
+(NSDate *)getYesterday:(NSDate*)now;
+(NSDate *)getTomorrow:(NSDate*)now;
@end
