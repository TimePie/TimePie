//
//  TimingItem.h
//  TimePie
//
//  Created by Max Lu on 4/30/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimingItem : NSManagedObject

@property (nonatomic, retain) NSString * item_name;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * color_r;
@property (nonatomic, retain) NSNumber * color_g;
@property (nonatomic, retain) NSNumber * color_b;

@end
