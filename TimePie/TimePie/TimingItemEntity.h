//
//  TimingItemEntity.h
//  TimePie
//
//  Created by Max Lu on 5/1/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimingItemEntity : NSManagedObject

@property (nonatomic, retain) NSString * item_name;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSNumber * item_id;

@end
