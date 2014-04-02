//
//  PersonalViewController.m
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "PersonalViewController.h"
#import "BasicUIColor+UIPosition.h"
#import "PersonalViewAvgTimeCell.h"

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
    _mainView.dataSource = self;
    _mainView.delegate = self;
    _mainView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    if (section == 0 && row == 0)
    {
        static NSString *CellIdentifier1 = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
      
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
        }
        cell.textLabel.text = @"查看范围";
        cell.textLabel.textColor = MAIN_UI_COLOR;
        cell.detailTextLabel.text = @"过去一周";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(section == 0 && row == 1)
    {
        static NSString *CellIdentifier2 = @"AvgTimeIdentifier";
        PersonalViewAvgTimeCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell1 == nil)
        {
            cell1 = [[PersonalViewAvgTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
    else
    {
        static NSString *CellIdentifier3 = @"Cell";
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if(cell2 == nil)
        {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier3];
        }
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    if (section == 0 || section == 2) return 50.0;
    else return 120.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.01;
    else return 16.0;
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
