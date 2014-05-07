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
@class Daily;

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


- (Daily*)getToday;



@end
