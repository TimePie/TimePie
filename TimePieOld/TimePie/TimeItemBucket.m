//
//  TimeItemBucket.m
//  TimePie
//
//  Created by Storm Max on 14-1-9.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import "TimeItemBucket.h"
#import "TimingItem.h"

@implementation TimeItemBucket


- (id)init
{
    self = [super init];
    if (self) {
        
        NSString *path= [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!allItems){
            allItems=[[NSMutableArray alloc] init];
        }
        if ([allItems count] ==0 ){
            [self createItem];
        }
    }
    return self;
}

- (NSArray *)allItems
{
    return allItems;
}

- (TimingItem *)createItem
{
    TimingItem *p= [TimingItem randomItem];
    [allItems addObject:p];
    return p;
}
+ (TimeItemBucket *)timeItemBucket
{
    static TimeItemBucket * timeBucket = nil;
    if (!timeBucket) {
        timeBucket = [[super allocWithZone:nil] init];
    }
    return timeBucket;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self timeItemBucket];
}

- (void)removeItem:(TimingItem *)p
{
    [allItems removeObjectIdenticalTo:p];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from==to) {
        return ;
    }
    TimingItem *p = [allItems objectAtIndex:from];
    [allItems removeObjectAtIndex:from];
    [allItems insertObject:p atIndex:to];
}

- (id)getItemAtIndex:(int)index
{
    
    TimingItem *item =[allItems objectAtIndex:index];
    if(item){
        return item;
    }else{
        return nil;
    }
}


- (NSString *)itemArchivePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"timeItems.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}


@end






