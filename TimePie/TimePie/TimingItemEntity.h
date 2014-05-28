//
//  TimingItemEntity.h
//  TimePie
//
//  Created by Max Lu on 5/28/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag, User;

@interface TimingItemEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * color_number;
@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSNumber * item_id;
@property (nonatomic, retain) NSString * item_name;
@property (nonatomic, retain) NSDate * last_check;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * timing;
@property (nonatomic, retain) NSNumber * tracking;
@property (nonatomic, retain) Tag *tag;
@property (nonatomic, retain) User *user;

@end
