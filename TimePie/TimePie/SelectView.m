//
//  SelectView.m
//  TimePie
//
//  Created by Max Lu on 5/13/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "SelectView.h"
#import "BasicUIColor+UIPosition.h"

@implementation SelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        viewHistory = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, 0, 250, 90)];
        cancelSelect =  [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+80, 0, 250, 90)];
        
        [viewHistory setImage:[UIImage imageNamed:@"History_btn"] forState:UIControlStateNormal];
        [cancelSelect setImage:[UIImage imageNamed:@"Cancel_btn"] forState:UIControlStateNormal];
        
        
        
        
        [self addSubview:viewHistory];
        [self addSubview:cancelSelect];
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
