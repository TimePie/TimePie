//
//  Daily.h
//  TimePie
//
//  Created by Max Lu on 6/9/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Daily : NSManagedObject

@property (nonatomic, retain) NSString * item_name;
@property (nonatomic, retain) NSString * tag_name;

@end
