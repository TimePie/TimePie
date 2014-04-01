//
//  PersonalViewController.m
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "PersonalViewController.h"
#import "BasicUIColor+UIPosition.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavBar];
    [self initMainView];
    [self initExitButton];
}

#pragma mark - init UI
- (void)initNavBar
{
    _navBar= [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *tempNavItem = [[UINavigationItem alloc] initWithTitle:@"个人中心"];
    [_navBar pushNavigationItem:tempNavItem animated:NO];
    _navBar.titleTextAttributes = @{NSForegroundColorAttributeName: MAIN_UI_COLOR};
    [self.view addSubview:_navBar];
}

- (void)initExitButton
{
    _exitButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-47, SCREEN_HEIGHT-62, 94, 57)];
    [_exitButton setImage:[UIImage imageNamed:@"TimePie_Personal_Exit_Button"] forState:UIControlStateNormal];
    [_exitButton addTarget:self action:@selector(exitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exitButton];
    [self.view.superview bringSubviewToFront:_exitButton];
}

- (void)initMainView
{
    _mainView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT*2) style:UITableViewStyleGrouped];
    _mainView.backgroundView = nil;
    _mainView.backgroundColor = [UIColor clearColor];
    _mainView.scrollEnabled = YES;
    _mainView.delegate = self;
    _mainView.dataSource = self;
    [self.view addSubview:_mainView];
}

#pragma mark - target selector
- (void)exitButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 10;
    }
    else if(section == 0) return 2;
    else return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    if (section == 0 || section == 2) return 50;
    else return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.01;
    else return 16;
}

//- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
