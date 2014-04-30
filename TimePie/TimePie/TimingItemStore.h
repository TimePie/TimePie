//
//  TimingItemStore.h
//  TimePie
//
//  Created by Max Lu on 4/30/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
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




@end
