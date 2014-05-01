//
//  TimingItemStore.m
//  TimePie
//
//  Created by Max Lu on 4/30/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "TimingItemStore.h"
#import "TimingItem1.h"
#import "BasicUIColor+UIPosition.h"
@implementation TimingItemStore


@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;


- (id)init
{
    self= [super init];
    if(self){
        if(!allItems){
            allItems = [[NSMutableArray alloc] init];
        }
        
        
        //[self restoreData];
        
        
    }
    return self;
}




- (NSArray *)allItems
{
    if(!allItems){
        allItems = [[NSMutableArray alloc] init];
    }
    return allItems;
}

- (TimingItem *)createItem{
    TimingItem *i = [TimingItem randomItem];
    [allItems addObject:i];
    NSLog(@"create item!");
    return i;
}

+ (TimingItemStore*) timingItemStore
{
    static TimingItemStore * timingItemStore = nil;
    if(!timingItemStore){
        timingItemStore = [[super allocWithZone:nil] init];
    }
    return timingItemStore;
}


+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self timingItemStore];
}

- (void)removeItem:(TimingItem *)i
{
    [allItems removeObjectIdenticalTo:i];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if(from==to){
        return;
    }
    TimingItem *i = [allItems objectAtIndex:from];
    [allItems removeObjectAtIndex:from];
    [allItems insertObject:i atIndex:to];
}


- (id)getItemAtIndex:(int)index
{
    TimingItem *item= [allItems objectAtIndex:index];
    if(item){
        return item;
    }else{
        return nil;
    }
}


- (BOOL)saveData
{
    BOOL result = NO;
    [self deletaAllItem];
    for(TimingItem * item in allItems){
        NSLog(@"Save!");
        result = [self insertItem:item];
    }
    return result;
}


- (BOOL)checkExisted:(TimingItem*)item
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date_created == %@",item.dateCreated]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *i in fetchedObjects){
        return YES;
    }
    return NO;
}


- (BOOL)insertItem:(TimingItem*)item
{
    BOOL result = YES;
    
    //insert
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *i = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"TimingItemEntity"
                                       inManagedObjectContext:context];
    [i setValue:item.itemName forKey:@"item_name"];
    [i setValue:[NSNumber numberWithInt:item.itemID] forKey:@"item_id"];
    [i setValue:[NSNumber numberWithDouble:item.time] forKey:@"time"];
    [i setValue:item.dateCreated forKey:@"date_created"];
    
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        result = NO;
    }
    
    return result;
}

- (BOOL)updateItem:(TimingItem*)item
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    BOOL result = YES;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date_created == %@",item.dateCreated]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *i in fetchedObjects) {
        [i setValue:item.itemName forKey:@"item_name"];
        [i setValue:[NSNumber numberWithInt:item.itemID] forKey:@"item_id"];
        [i setValue:[NSNumber numberWithDouble:item.time] forKey:@"time"];
        //NSLog([NSString stringWithFormat:@"time:%f", item.time]);
        //NSLog([NSString stringWithFormat:@"time:%@", [i valueForKey:@"time"]]);
        [i setValue:item.dateCreated forKey:@"date_created"];
    }
    
    [context updatedObjects];
    if ([context save:&error]) {
        NSLog(@"Did it!");
    } else {
        NSLog(@"Could not do it: %@", [error localizedDescription]);
        result = NO;
    }
    
    
    return result;
}

-(BOOL)deleteItem:(TimingItem*)item
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    BOOL result =YES;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date_created == %@",item.dateCreated]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        [context deleteObject:info];
    }
    
    
    if ([context save:&error]) {
        NSLog(@"Did it!");
    } else {
        NSLog(@"Could not do it: %@", [error localizedDescription]);
        result = NO;
    }
    
    
    return result;
}

- (BOOL)deletaAllItem
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    //Read
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        [context deleteObject:info];
    }
    
    if ([context save:&error]) {
        NSLog(@"Did it!");
    } else {
        NSLog(@"Could not do it: %@", [error localizedDescription]);
    }
    
    
    
    return YES;
}

- (BOOL)viewAllItem
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"item_name"]);
        NSLog(@"itemID: %@", [info valueForKey:@"item_id"]);
        NSLog(@"time: %@", [info valueForKey:@"time"]);
        NSLog(@"date_created: %@", [info valueForKey:@"date_created"]);
    }
    
    return YES;
}

- (BOOL)restoreData
{
    allItems = nil;
    allItems = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        TimingItem * item = [self createItem];
        item.itemName =[info valueForKey:@"item_name"];
        item.time = [[info valueForKey:@"time"] doubleValue];
        item.itemID =[[info valueForKey:@"item_id"] integerValue];
        item.dateCreated = [info valueForKey:@"date_created"];
    }
    
    [self restoreColors];
    
    
    return YES;
}


- (void)restoreColors
{
    
    if(allItems){
        int i =0;
        for(TimingItem * item in allItems){
            switch (i) {
                case 0:
                    item.color =REDNO1;
                    item.lightColor =RedNO1_light;
                    break;
                case 1:
                    item.color =BLUENO2;
                    item.lightColor =BLUENO2_light;
                    break;
                case 2:
                    item.color =GREENNO3;
                    item.lightColor = GREENNO3_light;
                    break;
                case 3:
                    item.color = PINKNO04;
                    item.lightColor = PINKNO04_light;
                    break;
                default:
                    item.color = [UIColor blackColor];
                    item.lightColor = [UIColor grayColor];
                    break;
            }
            
            i ++;
        }
    }
}





@end
