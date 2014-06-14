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
#import "TimingItemStore.h"


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
        
        
        
//        ringCircle= [[RingCircle alloc] initWithFrame:CGRectMake(0, 0, 100, 100) withPercentage:[[[TimingItemStore timingItemStore] getItemPercentage:item] doubleValue] withColor:[[ColorThemes colorThemes] getColorAt:item.itemColor]];
        double percentage=[[[TimingItemStore timingItemStore] getItemPercentage:item] doubleValue];
        ringCircle= [[RingCircle alloc] initWithFrame:CGRectMake(0, 0, 100, 100) withPercentage:percentage withColor:[[ColorThemes colorThemes] getColorAt:item.itemColor]];
        [self addSubview:ringCircle];
        
        UILabel *percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
        
        NSString *percentageStr =[NSString stringWithFormat:@"%.1f%%", [[[TimingItemStore timingItemStore] getItemPercentage:item] doubleValue]];
        CGSize size = [percentageStr sizeWithFont:[UIFont fontWithName:@"Ubuntu" size:10.f]];
        percentageLabel.text = percentageStr;
        percentageLabel.frame = CGRectMake(-size.width*.5, -size.height*.5, size.width, size.height);
        percentageLabel.font = [UIFont fontWithName:@"Ubuntu" size:10.f];
        percentageLabel.textColor = [UIColor whiteColor];
        [self addSubview:percentageLabel];

        
        
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, -10, 100, 20)];
        itemLabel.text = item.itemName;
        itemLabel.font = [UIFont fontWithName:@"Ubuntu" size:15.f];
        itemLabel.textColor = SHARING_TEXT_COLOR;
        itemLabel.layer.shadowColor = [SHARING_TEXT_COLOR CGColor];
        itemLabel.layer.shadowRadius = 3;
        itemLabel.layer.shadowOpacity =.5;
        itemLabel.layer.shadowOffset = CGSizeMake(0, 0);
        
        
        
        [self addSubview:itemLabel];
        
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, -10, 100, 20)];
        timeLabel.text = [item getTimeString];
        timeLabel.font = [UIFont fontWithName:@"Ubuntu" size:15.f];
        timeLabel.textColor = SHARING_TEXT_COLOR;
        
        timeLabel.layer.shadowColor = [SHARING_TEXT_COLOR CGColor];
        timeLabel.layer.shadowRadius = 3;
        timeLabel.layer.shadowOpacity =.5;
        timeLabel.layer.shadowOffset = CGSizeMake(0, 0);
        [self addSubview:timeLabel];
        
        
        
        
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
