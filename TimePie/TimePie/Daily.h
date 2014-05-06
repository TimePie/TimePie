//
//  Daily.h
//  TimePie
//
//  Created by Max Lu on 5/6/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TimingItemEntity, User;

@interface Daily : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *relationship;
@property (nonatomic, retain) User *user;
@end

@interface Daily (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(TimingItemEntity *)value;
- (void)removeRelationshipObject:(TimingItemEntity *)value;
- (void)addRelationship:(NSSet *)values;
- (void)removeRelationship:(NSSet *)values;

@end
