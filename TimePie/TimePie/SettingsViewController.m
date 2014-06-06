//
//  SettingsViewController.m
//  TimePie
//
//  Created by 大畅 on 14-4-20.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "SettingsViewController.h"
#import "BasicUIColor+UIPosition.h"
#import "SettingsThemeViewController.h"
#import "RoutineItemViewController.h"
#import "themeView.h"
#import "TimingItemStore.h"
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
    [self initVessel];
    [self initThemeInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[self.delegate reverseCloseButton];
}

#pragma mark - init UI
- (void)initNavBar
{
    self.title = @"设置";
}

- (void)initVessel
{
    _SVCVessel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _SVCVessel.dataSource = self;
    _SVCVessel.delegate = self;
    _SVCVessel.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [_SVCVessel setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_SVCVessel];
}

- (void)initThemeInfo
{
    _themeColors = [NSMutableArray arrayWithObjects:REDNO1,BLUENO2,GREENNO3, nil];
}

#pragma mark - tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 2;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return 3;}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *s1CellTitleArray = [NSArray arrayWithObjects:@"主题",@"我的例行事件表",@"我跟踪的标签", nil];
    NSArray *s2CellTitleArray = [NSArray arrayWithObjects:@"关于TimePie",@"为我们评分",@"", nil];
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (indexPath.section == 0) cell.textLabel.text = [s1CellTitleArray objectAtIndex:indexPath.row];
    else cell.textLabel.text = [s2CellTitleArray objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.f];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        themeView *tV = [[themeView alloc] initWithFrame:CGRectMake(160, 0, 140, 48)];
        [tV initThemeNameWithString:@"格里粉" ColorBoard:_themeColors];
        [cell addSubview:tV];
    }
    else if(indexPath.section == 1 && indexPath.row == 2)
    {
        cell.backgroundColor = REDNO1;
        [self initLabelInView:cell];
    }
    if(!(indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2))) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 48;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) return 35;
    else return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *UIFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UIFooterView.backgroundColor = [UIColor whiteColor];
    return UIFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        SettingsThemeViewController *stVC = [[SettingsThemeViewController alloc] init];
        [[self navigationController] pushViewController:stVC animated:YES];
    }
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        RoutineItemViewController *riVC = [[RoutineItemViewController alloc] init];
        [[self navigationController] pushViewController:riVC animated:YES];
    }
    else if(indexPath.section == 0 && indexPath.row == 2)
    {
        TrackItemViewController *tiVC = [[TrackItemViewController alloc] init];
        tiVC.delegate = self;
        [[self navigationController] pushViewController:tiVC animated:YES];
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        //about
    }
    else if(indexPath.section == 1 && indexPath.row == 1)
    {
        //评分
    }
    else if(indexPath.section == 1 && indexPath.row == 2)
    {
        //reset
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"是否清空数据" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1;
        [alert show];
        
    }
}

#pragma mark - TrackItemViewDelegate

- (void)reloadPass
{
    if ([self.delegate respondsToSelector:@selector(reloadSecondPass)])
    {
        NSLog(@"First Pass");
        [self.delegate reloadSecondPass];
    }
}

#pragma mark - utilities

- (void)initLabelInView:(UIView*)view
{
    UILabel *tempLabel =  [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 60, 14, 120, 20)];
    tempLabel.text = @"重置个人数据";
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.textAlignment = UITextAlignmentCenter;
    tempLabel.font = [UIFont boldSystemFontOfSize:17.f];
    [view addSubview:tempLabel];
}

#pragma mark - ui alert delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"test");
    if (alertView.tag==1) {
        if (buttonIndex == 1)
        {
            if([[TimingItemStore timingItemStore] deleteAllData])
            {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"成功清空数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];

            }
            else
            {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"清空数据失败，请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
