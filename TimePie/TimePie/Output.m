//
//  Output.m
//  TimePie
//
//  Created by Max Lu on 5/7/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "Output.h"
#import "GlobleConstants.h"


@implementation Output


+(void)println:(NSString*)str
{
    if(DEBUGGING){
        NSLog(str);
    }
}
@end
