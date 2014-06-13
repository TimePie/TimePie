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
#import "Daily.h"

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
- (NSNumber*)getItemPercentage:(TimingItem*)item;




/////////Core Data

- (BOOL)saveData;
- (BOOL)restoreData;

- (BOOL)deletaAllItem;
- (NSUInteger)viewAllItem;

- (BOOL)deleteAllData;


////


@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;




//Tags
- (BOOL)addTag:(TimingItem *)item
       TagName:(NSString *)name;
- (BOOL)addTag:(NSString*)name;
- (NSArray *)getAllTags;
- (NSArray *)getTimingItemsByTagName:(NSString *)tagName;
- (BOOL)markTracking:(NSString *)tagName Tracked:(NSNumber*)isTracking;



///

- (NSNumber *)getTotalHours;
- (NSNumber *)getTotalHoursByStartDate:(NSDate*)date;
- (NSNumber *)getTotalHoursByDate:(NSDate*)date
                            byTag:(NSString*)tagName;

//- (NSNumber *)getTotalDays;
- (NSNumber *)getTotalHoursByTag:(NSString*)tagName;

- (NSArray *)getDailyTimingsItemByTagName:(NSString*)tagName
                                     date:(NSDate *)date;
- (NSNumber *)getDailyTimeByTagName:(NSString*)tagName
                               date:(NSDate*)date;
- (NSArray*)getTimingItemsByDate:(NSDate *)date;


- (NSNumber*)getDailyTimeByItemName:(NSString*)itemName date:(NSDate*)date;
- (TimingItemEntity *)getDailyTimingItemByItemName:(NSString*)itemName date:(NSDate *)date;



// Dailys
- (BOOL)addDaily:(NSString*)name
             tag:(NSString*)tagName;
- (BOOL)removeDaily:(NSString*)name;
- (NSArray*)getAllDaily;
- (BOOL)updateDaily:(NSString*)fromName
           toName:(NSString*)toName;

- (BOOL)createDailyMark:(Daily*)daily
                   date:(NSDate*)date;



@end
