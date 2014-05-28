//
//  HorizontalScaleLineView.m
//  TimePie
//
//  Created by 黄泽彪 on 14-5-28.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "HorizontalScaleLineView.h"
#import "BasicUIColor+UIPosition.h"
@implementation HorizontalScaleLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"scaleLineBG"]];
        self.backgroundColor = bgColor;
        self.scaleLabel =  [[UILabel alloc]initWithFrame:CGRectMake(17, 0, 35, self.frame.size.height)];
        self.scaleLabel.text = @"2.3h";
        self.scaleLabel.textColor = MAIN_UI_COLOR;//[UIColor blackColor];
        self.scaleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:13];
        self.scaleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.scaleLabel];
        //self.backgroundColor = [UIColor lightGrayColor];
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
