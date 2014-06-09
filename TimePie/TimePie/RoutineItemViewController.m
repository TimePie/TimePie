//
//  RoutineItemViewController.m
//  TimePie
//
//  Created by 大畅 on 14-5-12.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "RoutineItemViewController.h"
#import "TimingItem1.h"
#import "TimingItemEntity.h"
#import "TimingItemStore.h"
#import "Daily.h"
#import "BasicUIColor+UIPosition.h"

@interface RoutineItemViewController ()

@end

@implementation RoutineItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的例行事件表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initRoutineData];
    [self initTableView];
}

- (void) initRoutineData
{
    self.routineDataArray = [[TimingItemStore timingItemStore] getAllDaily];
}

- (void) initTableView
{
    self.routineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.routineTableView.dataSource = self;
    self.routineTableView.delegate = self;
    //self.routineTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [self.routineTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview: self.routineTableView];
    
    [self setExtraCellLineHidden: self.routineTableView];
}
//delete useless lines
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



#pragma mark - tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routineDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"RoutineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
  
    cell.textLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.f];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int index = indexPath.row;
    Daily *tempDaily = [self.routineDataArray objectAtIndex:index];
    
    cell.textLabel.text = tempDaily.item_name;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除例行事件
        int index = indexPath.row;
        Daily *tempDaily = [self.routineDataArray objectAtIndex:index];

        [[TimingItemStore timingItemStore] removeDaily:tempDaily.item_name];
        [self initRoutineData];
        [self.routineTableView reloadData];
    }
}


//自定义 delete
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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
