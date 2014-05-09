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
#import "Tag.h"
#import "DateHelper.h"
#import "TimingItemEntity.h"

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

- (TimingItem *)createItem:(TimingItem*)item
{
    TimingItem *i = [TimingItem randomItem];
    i.color = item.color;
    i.lastCheck = item.lastCheck;
    i.itemName = item.itemName;
    item.time +=1;
    i.time = item.time;
    i.timing= item.timing;
    [allItems insertObject:i atIndex:[allItems count]];
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
    [self deleteItem:i];
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
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
//    [self deletaAllItem];
//    NSLog(@"Save!");
    for(TimingItem * item in allItems){
        TimingItemEntity *i = [self getItemEntityByItem:item];
        [i setValue:item.itemName forKey:@"item_name"];
        [i setValue:[NSNumber numberWithInt:item.itemID] forKey:@"item_id"];
        [i setValue:[NSNumber numberWithDouble:item.time] forKey:@"time"];
        [i setValue:item.dateCreated forKey:@"date_created"];
        [i setValue:item.lastCheck forKey:@"last_check"];
        [i setValue:[NSNumber numberWithInt:item.color] forKey:@"color_number"];
        [i setValue:[NSNumber numberWithBool:item.timing] forKeyPath:@"timing"];
        [context updatedObjects];
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            result = NO;
        }
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
    
    NSManagedObject * i = [self saveItemEntity:item];

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
        [self updateItemEntityFromItem:item to:i];
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
    
    NSLog(@"restore data!");
    allItems = nil;
    allItems = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSDate *today = [NSDate date];
    NSDate *startOfToday = [DateHelper beginningOfDay:today];
    NSDate *endOfToday = [DateHelper endOfDay:today];
    
    NSLog([NSString stringWithFormat:@"start: %@",startOfToday]);
    NSLog([NSString stringWithFormat:@"end: %@",endOfToday]);
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"((date_created >= %@) AND (date_created <= %@)) OR timing = %@", startOfToday, endOfToday, [NSNumber numberWithBool:true]]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    NSLog(@"[restoredata]number of object returned: %d",[fetchedObjects count]);
    for (TimingItemEntity *i in fetchedObjects) {
        
        TimingItem* item = [self restoreItem:i];
        
        if(item.timing == YES){// if i is a timing item
            
            BOOL flag = true;
            if ([item.dateCreated compare:startOfToday] == NSOrderedAscending) {
                flag = false;
            }
            if ([item.dateCreated compare:endOfToday] == NSOrderedDescending) {
                flag = false;
            }
            
            
            
            if(flag)   //timing item is today's item;  Do nothing;
            {
                NSLog(@"timing item is today's item, do nothing");
            }else{    //timing item is not today's item; create new item and abandon this item;
                NSLog(@"Timing item is no today's item; create a new one and reload.");
                TimingItem* newTimingItem = [self createItem:item];
                item.timing = NO;
                [self updateItem:item];
                [allItems removeObjectIdenticalTo:item];
                [self saveData];
                //[self restoreData];
                
            }
        }
        
    }
    
    
    if(allItems&&[allItems count]!=0){
        [[[self allItems] objectAtIndex:0] check:YES];
        NSLog([[[self allItems] objectAtIndex:0] itemName]);
    }
    
    
    for(int i=0;i<[allItems count];i++){
        if(((TimingItem*)[allItems objectAtIndex:i]).timing == YES){
            [self moveItemAtIndex:i toIndex:0];
        }
    }
    
    return YES;
}



- (NSArray*)getTimingItemsByDate:(NSDate *)date
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSDate *startOfToday = [DateHelper beginningOfDay:date];
    NSDate *endOfToday = [DateHelper endOfDay:date];
    
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(date_created >= %@) AND (date_created <= %@)", startOfToday, endOfToday]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"[restoredata]number of object returned: %d",[fetchedObjects count]);
    for(NSManagedObject* i in fetchedObjects){
        NSLog(@"item:%@", i);
    }
    return fetchedObjects;
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
    item.timing = [[i valueForKey:@"timing"] boolValue];
    return item;
}

- (NSManagedObject *)updateItemEntityFromItem:(TimingItem*)item
                             to:(NSManagedObject*)i
{
    
    [i setValue:item.itemName forKey:@"item_name"];
    [i setValue:[NSNumber numberWithInt:item.itemID] forKey:@"item_id"];
    [i setValue:[NSNumber numberWithDouble:item.time] forKey:@"time"];
    [i setValue:item.dateCreated forKey:@"date_created"];
    [i setValue:item.lastCheck forKey:@"last_check"];
    [i setValue:[NSNumber numberWithInt:item.color] forKey:@"color_number"];
    [i setValue:[NSNumber numberWithBool:item.timing] forKey:@"timing"];
    
    return i;
}



//get a single item entity from TimingTime Class
//no longer used
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
    [i setValue:[NSNumber numberWithBool:item.timing] forKey:@"timing"];
    
    
    return i;
    
}





- (BOOL)addTag:(TimingItem *)item
       TagName:(NSString *)name
{
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    Tag * tag ;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Tag" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tag_name == %@",name]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"tag_name"]);
    }
    if([fetchedObjects count]==0){
        tag = (Tag*)[NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                              inManagedObjectContext:context];
        
        [tag setValue:name forKey:@"tag_name"];
    }else{
        tag = (Tag*)[fetchedObjects objectAtIndex:0];
    }
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return false;
    }
    
    
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date_created == %@",item.dateCreated]];
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"item_name"]);
    }
    TimingItemEntity * i = [fetchedObjects objectAtIndex:0];
    i.tag = tag;
    [tag addItemObject:i];
    
    [context updatedObjects];
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return false;
    }
    
    
    
    
    ///check if it works
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tag_name == %@",name]];
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    tag = [fetchedObjects objectAtIndex:0];
    for(TimingItemEntity * i  in tag.item){
        NSLog(@"item entity for tag:%@", i);
    }

    return true;
}



- (NSManagedObject *)getItemEntityByItem: (TimingItem*)item
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date_created == %@",item.dateCreated]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if([fetchedObjects count]==0){
        NSManagedObject *i = [NSEntityDescription
                              insertNewObjectForEntityForName:@"TimingItemEntity"
                              inManagedObjectContext:context];
        return i;
    }

    for(NSManagedObject * i in fetchedObjects){
        NSLog(@"got item!%@",i);
        return i;
    }
    
    
    return nil;
}



- (NSArray *)getTimingItemsByTagName:(NSString *)tagName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    Tag * tag ;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Tag" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tag_name == %@",tagName]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"tag_name"]);
    }
    
    if([fetchedObjects count]==0){
        tag = (Tag*)[NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                  inManagedObjectContext:context];
        [tag setValue:tagName forKey:@"tag_name"];
    }else{
        tag = (Tag*)[fetchedObjects objectAtIndex:0];
    }
    
    
    for(TimingItemEntity * i  in tag.item){
        NSLog(@"item entity for tag:%@", i);
    }
    
    if(tag==nil){
        return nil;
    }
    
    return [tag.item allObjects];
}



- (NSNumber *)getDailyTimeByTagName:(NSString*)tagName
                               date:(NSDate*)date
{
    NSArray * items = [self getDailyTimingsItemByTagName:tagName date:date];
    double total = 0;
    for(TimingItemEntity * item in items){
        total+= [item.time doubleValue];
    }
    NSLog(@"total time:%f", total);
    return [NSNumber numberWithDouble:total];
}


- (NSMutableArray *)getDailyTimingsItemByTagName:(NSString*)tagName
                                    date:(NSDate *)date
{
    NSArray * items = [self getTimingItemsByTagName:tagName];
    NSLog(@"%@",items);
    NSDate * startDate = [DateHelper beginningOfDay:date];
    NSDate * endDate = [DateHelper endOfDay:date];
    NSLog(@"current date:%@",date);
    NSLog(@"start date:%@",startDate);
    NSLog(@"end date:%@",endDate);
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for(TimingItemEntity * item in items){
        BOOL flag = true;
        if ([item.date_created compare:startDate] == NSOrderedAscending) {
            flag = false;
        }
        if ([item.date_created compare:endDate] == NSOrderedDescending) {
            flag = false;
        }
        if(flag){
            [results addObject:item];
        }
        
    }
    NSLog(@"results count:%d",[results count]);
    return results;
}


- (BOOL)markTracking:(NSString *)tagName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    Tag * tag ;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Tag" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tag_name == %@",tagName]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"tag_name"]);
    }
    if([fetchedObjects count]==0){
        tag = (Tag*)[NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                  inManagedObjectContext:context];
        [tag setValue:tagName forKey:@"tag_name"];
    }else{
        tag = (Tag*)[fetchedObjects objectAtIndex:0];
    }
    
    tag.tracking = [NSNumber numberWithBool:true];
    [context updatedObjects];
    
    
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return false;
    }
    
    return true;
}



- (NSNumber *)getTotalDays
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TimingItemEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"date_created" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByDate]];
    [fetchRequest setFetchLimit:1];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"date_created....: %@", [info valueForKey:@"date_created"]);
    }
    if([fetchedObjects count]==0){
        NSLog(@"Empty");
        return 0;
    }
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:(NSDate*)[[fetchedObjects objectAtIndex:0]
                                             valueForKey:@"date_created"]
                                                  toDate:[NSDate date] options:0];
    NSInteger days = [components day];
    //test:
    NSInteger minutes = [components second];
    return [NSNumber numberWithInteger:minutes];
}





@end
