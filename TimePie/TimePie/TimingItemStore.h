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



@interface TimingItemStore : NSObject
{
    NSMutableArray *allItems;
}



+ (TimingItemStore *)timingItemStore;
- (void)removeItem:(TimingItem *)i;
- (NSArray *)allItems;
- (TimingItem *)createItem;
- (id)getItemAtIndex:(int)index;

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;


- (BOOL)saveData;
- (BOOL)restoreData;


- (BOOL)insertItem:(TimingItem*)item;
- (BOOL)updateItem:(TimingItem*)item;
- (BOOL)deleteItem:(TimingItem*)item;
- (BOOL)deletaAllItem;
- (BOOL)viewAllItem;



@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;






@end
