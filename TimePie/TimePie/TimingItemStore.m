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
#import "ColorThemes.h"
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




//create item methods automatically insert the item into   allItem
//The color number of an item is picked based on the number of objects in   allItem
//Later we can use ColorTheme to manage the colors to avoid the duplicated colors.
- (TimingItem *)createItem{
    TimingItem *i = [TimingItem randomItem];
    i.color = [allItems count];
    [allItems addObject:i];
    NSLog(@"create item!");
    return i;
}

//Class method, reture a single TimingItemStore object.
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

//remove the item from allItem
//**this method DO NOT remove item from coredata
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
    if(!allItems||[allItems count]==0){
        return nil;
    }
    TimingItem *item= [allItems objectAtIndex:index];
    if(item){
        return item;
    }else{
        return nil;
    }
}




// Save items array to core data
- (BOOL)saveData
{
    BOOL result = NO;
    [self deletaAllItem];
    NSLog(@"Save!");
    for(TimingItem * item in allItems){
        
        [item check:NO];
        result = [self insertItem:item];
    }
    return result;
}




//check if there is a same item existed
//###Deprecated####
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





//insert an item to coredata
// no longer public
- (BOOL)insertItem:(TimingItem*)item
{
    BOOL result = YES;
    
    //insert
    NSManagedObjectContext *context = [self managedObjectContext];
    
    [self saveItemEntity:item];
    /////
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        result = NO;
    }
    
    return result;
}



// update an item to coredata
// no longer public
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
        [self restoreItem:i];
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

// delete an item from coredata
// no longer public
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


// delete all items from coredata
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

// view all items in coredata
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
    for (NSManagedObject *i in fetchedObjects) {
        [self restoreItem:i];
    }
    
    
    if(allItems&&[allItems count]!=0){
        [[[self allItems] objectAtIndex:0] check:YES];
        NSLog([[[self allItems] objectAtIndex:0] itemName]);
    }
    
    return YES;
}






// restore a single item from NSManagedObject
- (TimingItem* )restoreItem:(NSManagedObject *)i
{
    TimingItem * item = [self createItem];
    item.itemName =[i valueForKey:@"item_name"];
    item.time = [[i valueForKey:@"time"] doubleValue];
    item.itemID =[[i valueForKey:@"item_id"] integerValue];
    item.dateCreated = [i valueForKey:@"date_created"];
    item.lastCheck = [i valueForKey:@"last_check"];
    item.color = [[i valueForKey:@"color_number"] integerValue];
    return item;
}



//get a single item entity from TimingTime Class
- (NSManagedObject *)saveItemEntity:(TimingItem *)item
{
    //insert
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *i = [NSEntityDescription
                          insertNewObjectForEntityForName:@"TimingItemEntity"
                          inManagedObjectContext:context];
    
    [i setValue:item.itemName forKey:@"item_name"];
    [i setValue:[NSNumber numberWithInt:item.itemID] forKey:@"item_id"];
    [i setValue:[NSNumber numberWithDouble:item.time] forKey:@"time"];
    [i setValue:item.dateCreated forKey:@"date_created"];
    [i setValue:item.lastCheck forKey:@"last_check"];
    [i setValue:[NSNumber numberWithInt:item.color] forKey:@"color_number"];
    return i;
    
}



@end
