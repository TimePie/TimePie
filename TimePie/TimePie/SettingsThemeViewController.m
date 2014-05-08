//
//  SettingsThemeViewController.m
//  TimePie
//
//  Created by 大畅 on 14-5-8.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "SettingsThemeViewController.h"

@interface SettingsThemeViewController ()

@end

@implementation SettingsThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        [[self navigationController].view viewWithTag:3001].hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"主题";
    [[self navigationController].view viewWithTag:3001].hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
