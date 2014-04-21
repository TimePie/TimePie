//
//  SettingsViewController.m
//  TimePie
//
//  Created by 大畅 on 14-4-20.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "SettingsViewController.h"
#import "BasicUIColor+UIPosition.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    [super viewDidLoad];
    [self initNavBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate reverseCloseButton];
}

#pragma mark - init UI
- (void)initNavBar
{
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
