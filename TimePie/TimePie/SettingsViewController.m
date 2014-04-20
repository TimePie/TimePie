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

#pragma mark - init UI
- (void)initNavBar
{
    _navBar= [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *tempNavItem = [[UINavigationItem alloc] initWithTitle:@"设置"];
    
    UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [tempBtn setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:tempBtn];
    tempNavItem.rightBarButtonItem = closeButton;
    
    [_navBar pushNavigationItem:tempNavItem animated:NO];
    _navBar.titleTextAttributes = @{NSForegroundColorAttributeName: MAIN_UI_COLOR};
    [self.view addSubview:_navBar];
}

#pragma mark - target selector
- (void)closeButtonPressed
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
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
