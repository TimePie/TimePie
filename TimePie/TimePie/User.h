//
//  User.h
//  TimePie
//
//  Created by Max Lu on 5/7/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag, TimingItemEntity;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * start_date;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSSet *item;
@property (nonatomic, retain) NSSet *tag;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addItemObject:(TimingItemEntity *)value;
- (void)removeItemObject:(TimingItemEntity *)value;
- (void)addItem:(NSSet *)values;
- (void)removeItem:(NSSet *)values;

- (void)addTagObject:(Tag *)value;
- (void)removeTagObject:(Tag *)value;
- (void)addTag:(NSSet *)values;
- (void)removeTag:(NSSet *)values;

@end
