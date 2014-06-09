//
//  AboutTimePieViewController.m
//  TimePie
//
//  Created by 大畅 on 14/6/9.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "AboutTimePieViewController.h"

@implementation AboutTimePieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"关于TimePie";
}

@end
