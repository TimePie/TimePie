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

@end
