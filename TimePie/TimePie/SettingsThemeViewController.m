//
//  SettingsThemeViewController.m
//  TimePie
//
//  Created by 大畅 on 14-5-8.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "SettingsThemeViewController.h"
#import "SettingsViewController.h"
#import "BasicUIColor+UIPosition.h"
#import "themeDetailView.h"

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
    [self initNeededData];
    [self initMainVessel];
}

- (void)initNeededData
{
    themeList = [NSMutableArray arrayWithObjects:@"格里粉",@"格里绿",@"格里蓝", nil];
    NSArray *theme1Color = [NSArray arrayWithObjects:REDNO1,BLUENO2,GREENNO3,BROWNN05,PINKNO04, nil];
    NSArray *theme2Color = [NSArray arrayWithObjects:BLUENO2,GREENNO3,REDNO1,PINKNO04,BROWNN05, nil];
    NSArray *theme3Color = [NSArray arrayWithObjects:BROWNN05,PINKNO04,BLUENO2,REDNO1,GREENNO3, nil];
    themeColorList = [NSMutableArray arrayWithObjects:theme1Color,theme2Color,theme3Color, nil];
}

- (void)initMainVessel
{
    _STVC_Vessel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _STVC_Vessel.dataSource = self;
    _STVC_Vessel.delegate = self;
    _STVC_Vessel.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [_STVC_Vessel setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_STVC_Vessel];
}

#pragma mark - tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return 3;}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    themeDetailView *tdV = [[themeDetailView alloc] initWithFrame:CGRectMake(190, 0, 140, 48)];
    [tdV initThemeWithColorBoard:[themeColorList objectAtIndex:indexPath.row]];
    [cell addSubview:tdV];
    
    cell.textLabel.text = [themeList objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.f];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 48;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
