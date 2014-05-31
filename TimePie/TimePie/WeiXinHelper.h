//
//  WeiXinHelper.h
//  TimePie
//
//  Created by Max Lu on 5/31/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "WXApi.h"

@interface WeiXinHelper : NSObject



+ (void) sendContent:(NSString *)text image:(UIImage *)img;
@end
