//
//  TimingItemStore.h
//  TimePie
//
//  Created by Max Lu on 4/30/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TimingItem1.h"
#import "TimingItemEntity.h"

@class Tag;
@class Tracking;

@interface TimingItemStore : NSObject
{
    NSMutableArray *allItems;
}



+ (TimingItemStore *)timingItemStore;
- (void)removeItem:(TimingItem *)i;
- (NSArray *)allItems;
- (TimingItem *)createItem;
- (TimingItem *)createItem:(TimingItem*)item;
- (id)getItemAtIndex:(int)index;

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;




/////////Core Data

- (BOOL)saveData;
- (BOOL)restoreData;

- (BOOL)deletaAllItem;
- (BOOL)viewAllItem;


////


@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;





- (BOOL)addTag:(TimingItem *)item
       TagName:(NSString *)name;
- (NSArray*)getAllTags;
- (NSArray *)getTimingItemsByTagName:(NSString *)tagName;
- (BOOL)markTracking:(NSString *)tagName;



///
- (NSNumber *)getTotalDays;
- (NSArray *)getDailyTimingsItemByTagName:(NSString*)tagName
                                     date:(NSDate *)date;
- (NSNumber *)getDailyTimeByTagName:(NSString*)tagName
                               date:(NSDate*)date;
- (NSArray*)getTimingItemsByDate:(NSDate *)date;


- (NSNumber*)getDailyTimeByItemName:(NSString*)itemName date:(NSDate*)date;
- (TimingItemEntity *)getDailyTimingItemByItemName:(NSString*)itemName date:(NSDate *)date;

@end
