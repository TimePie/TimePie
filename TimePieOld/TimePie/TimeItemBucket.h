//
//  TimeItemBucket.h
//  TimePie
//
//  Created by Storm Max on 14-1-9.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TimingItem;

@interface TimeItemBucket : NSObject{
    NSMutableArray * allItems;
}




+ (TimeItemBucket *)timeItemBucket;
- (void)removeItem:(TimingItem *)p;
- (NSArray *)allItems;
- (NSArray *)createItem;
- (id)getItemAtIndex:(int)index;

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;

- (BOOL)saveChanges;


@end
