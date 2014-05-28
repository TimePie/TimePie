//
//  TrackItemViewController.m
//  TimePie
//
//  Created by 大畅 on 14-5-12.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "TrackItemViewController.h"
#import "TimingItemStore.h"
#import "Tag.h"

@interface TrackItemViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *tagListArray;
    NSMutableArray *trackedTagList;
}
@property (strong, nonatomic) UITableView *TIVC_Vessel;

@end

@implementation TrackItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initNeededData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我跟踪的标签";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMainVessel];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(reloadPass)])
    {
        [self.delegate reloadPass];
    }
}

- (void)initMainVessel
{
    _TIVC_Vessel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    _TIVC_Vessel.separatorInset = UIEdgeInsetsZero;
    _TIVC_Vessel.dataSource = self;
    _TIVC_Vessel.delegate = self;
    _TIVC_Vessel.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [self.view addSubview:_TIVC_Vessel];
}

- (void)initNeededData
{
    NSArray *tempTagArray = [[TimingItemStore timingItemStore] getAllTags];
    tagListArray = [NSMutableArray arrayWithArray:tempTagArray];
    trackedTagList = [NSMutableArray arrayWithObjects:@"n",@"n",@"y",@"n",@"n",@"n", nil];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tagListArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =[NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[tagListArray objectAtIndex:indexPath.row] tag_name]];
    cell.textLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.f];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16.f];
    if ([[(Tag*)[tagListArray objectAtIndex:indexPath.row] tracking] intValue] == 0)
    {
        [self initTrackSelectedViewInCell:cell withIndexPath:indexPath withImage:[UIImage imageNamed:@"TimePie_Settings_unTracked"]];
    }
    else [self initTrackSelectedViewInCell:cell withIndexPath:indexPath withImage:[UIImage imageNamed:@"TimePie_Settings_Tracked"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 48;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[(Tag*)[tagListArray objectAtIndex:indexPath.row] tracking] intValue] == 0)
    {
        //[trackedTagList replaceObjectAtIndex:indexPath.row withObject:@"n"];
        [[TimingItemStore timingItemStore] markTracking:[[tagListArray objectAtIndex:indexPath.row] tag_name] Tracked:[NSNumber numberWithInt:1]];
    }
    else
    {
        //[trackedTagList replaceObjectAtIndex:indexPath.row withObject:@"y"];
        [[TimingItemStore timingItemStore] markTracking:[[tagListArray objectAtIndex:indexPath.row] tag_name] Tracked:[NSNumber numberWithInt:0]];
    }
    [_TIVC_Vessel reloadData];
}

#pragma mark - utilities

- (void)initTrackSelectedViewInCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath withImage:(UIImage*)image
{
    UIImageView *trackImg = [[UIImageView alloc] initWithFrame:CGRectMake(250, 11, 59, 26)];
    trackImg.image = image;
    [cell addSubview:trackImg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
