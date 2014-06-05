//
//  SharingTimingItemView.m
//  TimePie
//
//  Created by Max Lu on 6/5/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//


#import "SharingTimingItemView.h"
#import "ColorThemes.h"
#import "BasicUIColor+UIPosition.h"

@implementation SharingTimingItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ringCircle= [[RingCircle alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 100, 100) withPercentage:50 withColor:[UIColor blackColor]];
        [self addSubview:ringCircle];
        
        
        /*
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 300 + 20 , 100, 20)];
        itemLabel.text = [[itemList objectAtIndex:i] itemName];
        itemLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:15.f];
        itemLabel.textColor = [[ColorThemes colorThemes] getColorAt:[[itemList objectAtIndex:i] itemColor]];
        [self.view addSubview:itemLabel];
         */
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
           withItem:(TimingItem*)item
{
    self = [super initWithFrame:frame];
    if (self) {
        ringCircle= [[RingCircle alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 100, 100) withPercentage:50 withColor:[[ColorThemes colorThemes] getColorAt:item.itemColor]];
        [self addSubview:ringCircle];
        
        
        
         UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 100, 20)];
         itemLabel.text = [item itemName];
         itemLabel.font = [UIFont fontWithName:@"Ubuntu" size:15.f];
         itemLabel.textColor = SHARING_TEXT_COLOR;
         [self addSubview:itemLabel];
        
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
