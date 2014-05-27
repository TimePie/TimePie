//
//  StatsViewController.m
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "StatsViewController.h"
#import "StatsItemTableViewCell.h"
#import "GraphTypeEnum.h"
#import "TimingItem1.h"
#import "TimingItemEntity.h"
#import "TimingItemStore.h"
#import "Tag.h"
#import "ColorThemes.h"
@interface StatsViewController ()
{
    //record the current graph type
    GraphType currentType;
    NSArray *graphArray;
}

@end

@implementation StatsViewController

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
    
    [self initNavigationBar];
    
    currentType = WeekType;
    //
    [self initSegmentedControl];
    
    //get the data from last view
    //...
    [self initItemData];
    
    [self initDate];
    //
    [self initGraphs];
    
    [self initMonthGraph];
    
    [self initDaysGraph];
    
    graphArray = [NSArray arrayWithObjects: self.daysGraph, self.lineGraph, self.monthGraph, nil];
    [self setGraphViewActive:currentType];
}

- (void)initNavigationBar
{
    //[self.navigationItem setBackBarButtonItem:[[UINavigationItem alloc] se ]]
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"StatsBackButton"] style:nil target:self action:@selector(exitButtonPressed)];//initWithTitle:@"t" style:UIBarButtonItemStyleBordered:self action:@selector(exitButtonPressed)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    [self.navigationBar pushNavigationItem:self.navigationItem animated:NO];  //.leftBarButtonItem= backButton;
    
    self.navigationBar.topItem.title=@"历史回顾";
    
    self.navigationBar.clipsToBounds = YES;
    //[[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
}

- (void)initSegmentedControl
{
    self.segmentedControl.selectedSegmentIndex =1;//设置默认选择项索引
    [self.segmentedControl setTitle:@"过去三天" forSegmentAtIndex:2];
    [self.segmentedControl addTarget:self action: @selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    //self.segmentedControl.frame = CGRectMake(20.0, 20.0, 250.0, 90.0);
}

#pragma mark - graph view data
- (void)initItemData
{
    //手动保存 数据库的数据
    [[TimingItemStore timingItemStore] saveData];
    
    self.itemDataArray = [[NSMutableArray alloc]init];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    
    //item data，一次性获得30天数据。
    for (int i = 0; i < self.timingItemArray.count; i++)
    {
        TimingItem *tempTimingItem = [self.timingItemArray objectAtIndex:i];
        
        NSMutableArray *tempValues = [[NSMutableArray alloc] init];
        for(int count = 0;count <30;count++)
        {
            NSNumber *tempData = [NSNumber numberWithInt:0];
            
            //若无该事项，则默认为0
            @try {
                [comps setDay:-count];
                NSDate *tempDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
                
                /**
                 *  real data
                 */
                //tempData = [[TimingItemStore timingItemStore] getDailyTimeByItemName:tempTimingItem.itemName date:tempDate];
                
                /**
                 *  fake data
                 */
                tempData = [NSNumber numberWithInteger:(arc4random() % 7)];
                
            }
            @catch (NSException *exception) {
                tempData = [NSNumber numberWithInt:0];
                //tempData = [NSNumber numberWithInteger:(arc4random() % 7000)];
            }
            
//            if (tempData == 0) {
//                tempData = [NSNumber numberWithInteger:(arc4random() % 7000)];
//            }
            [tempValues addObject:tempData];
        }
        ZBStatsItemData *itemTemp=[[ZBStatsItemData alloc] initWithName:tempTimingItem.itemName
                                                                  Color:[[ColorThemes colorThemes] getColorAt:tempTimingItem.color]
                                                           MonthData:tempValues
                                                          AndSecondTime:tempTimingItem.time];
        
        [self.itemDataArray addObject:itemTemp];
    }
    
}

- (void)initDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    //格式化日期期
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"M.dd"];
    
    self.ArrayOfDates = [[NSMutableArray alloc] init];
    
    //一次性获取一个月内的日期string
    // 0 表示 今日 的数据
    for (int i=0; i < 30; i++)
    {
        NSString *tempS=@"";
        if(i == 0)
        {
            tempS=@"今日";
        }
        else
        {
            [comps setDay:-i];
            NSDate *tempDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
            //
            tempS=[dateformatter stringFromDate:tempDate];
        }
        [self.ArrayOfDates addObject:tempS];
    }

}

#pragma mark - graph view init
- (void)initGraphs
{
    //TODO: rewrite this part
    //使数据模型和视图分开
    
    //create view for graph
    self.lineGraph = [[StatsLineGraphView alloc] initWithFrame:CGRectMake(-4, 130, 320, 240)];
    
    //self.lineGraph.backgroundColor=[UIColor blackColor];
    
    
    self.lineGraph.delegate = self;
    
    self.lineGraph.graphType = currentType;
    
    self.lineGraph.itemCount = self.itemDataArray.count;
    
    //set attributes
    //self.lineGraph.colorTop = [UIColor whiteColor];
    
//    self.lineGraph.colorBottom = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:0.5]; // Leaving this not-set on iOS 7 will default to your window's tintColor
//    self.lineGraph.colorLine = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:1.0];
    
    self.lineGraph.alphaBottom = 0.3;
    self.lineGraph.alphaLine = 0.8;
    self.lineGraph.colorXaxisLabel = [UIColor colorWithRed:99.0/255.0 green:183.0/255.0 blue:170.0/255.0 alpha:1.0];
    self.lineGraph.labelFont=[UIFont fontWithName:@"Roboto-Medium" size:11];
    self.lineGraph.widthLine = 1.5;
    self.lineGraph.enableTouchReport = YES;
    self.lineGraph.animationGraphEntranceSpeed=0;
    
    //set graph color
    //maybe set it to delegate
    self.lineGraph.colorsOfGraph=self.colorArray;
    
    [self.view addSubview:self.lineGraph];
    
}

- (void)initMonthGraph
{
    //create view for graph
    self.monthGraph = [[StatsLineGraphView alloc] initWithFrame:CGRectMake(-4, 130, 320, 240)];
    //self.lineGraph.backgroundColor=[UIColor blackColor];
    
    
    self.monthGraph.delegate = self;
    
    self.monthGraph.graphType = MonthType;
    
    self.monthGraph.itemCount = self.itemDataArray.count;
    
    //set attributes
    //self.lineGraph.colorTop = [UIColor whiteColor];
    
    //    self.lineGraph.colorBottom = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:0.5]; // Leaving this not-set on iOS 7 will default to your window's tintColor
    //    self.lineGraph.colorLine = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:1.0];
    
    self.monthGraph.alphaBottom = 0.3;
    self.monthGraph.alphaLine = 0.8;
    self.monthGraph.colorXaxisLabel = [UIColor colorWithRed:99.0/255.0 green:183.0/255.0 blue:170.0/255.0 alpha:1.0];
    self.monthGraph.labelFont=[UIFont fontWithName:@"Roboto-Medium" size:11];
    self.monthGraph.widthLine = 1.5;
    self.monthGraph.enableTouchReport = YES;
    self.monthGraph.animationGraphEntranceSpeed=0;
    
    //set graph color
    //maybe set it to delegate
    self.monthGraph.colorsOfGraph=self.colorArray;
    
    [self.view addSubview:self.monthGraph];

}

- (void)initDaysGraph
{
    //create view for graph
    self.daysGraph = [[StatsLineGraphView alloc] initWithFrame:CGRectMake(-4, 130, 320, 240)];
    
    //self.lineGraph.backgroundColor=[UIColor blackColor];
    
    
    self.daysGraph.delegate = self;
    
    self.daysGraph.graphType = ThreeDayType;
    
    self.daysGraph.itemCount = self.itemDataArray.count;
    
    //set attributes
    //self.lineGraph.colorTop = [UIColor whiteColor];
    
    //    self.lineGraph.colorBottom = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:0.5]; // Leaving this not-set on iOS 7 will default to your window's tintColor
    //    self.lineGraph.colorLine = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:1.0];
    
    self.daysGraph.alphaBottom = 0.3;
    self.daysGraph.alphaLine = 0.8;
    self.daysGraph.colorXaxisLabel = [UIColor colorWithRed:99.0/255.0 green:183.0/255.0 blue:170.0/255.0 alpha:1.0];
    self.daysGraph.labelFont=[UIFont fontWithName:@"Roboto-Medium" size:11];
    self.daysGraph.widthLine = 1.5;
    self.daysGraph.enableTouchReport = YES;
    self.daysGraph.animationGraphEntranceSpeed=0;
    
    //set graph color
    //maybe set it to delegate
    self.daysGraph.colorsOfGraph=self.colorArray;
    
    [self.view addSubview:self.daysGraph];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - graph view manage method

- (void)setGraphViewActive:(GraphType)type
{
    for (int i = 0; i < graphArray.count; i++)
    {
        StatsLineGraphView *temp = [graphArray objectAtIndex:i];
        [temp setHidden:YES];
        if (temp.graphType == type)
        {
            [temp setHidden:NO];
        }
    }
}


#pragma mark - Data Source for graph view

//- (int)numberOfXaxisPoints {
//    
//    //TODO: use graph index to index the generating graph
//    
//    return 7;//(int)[self.ArrayOfDates count];
//}
//
//- (int)numberOfAllPoints{
//    return 0;//(int)[self.statsItemData.AllItemData count];
//}

- (float)valueForIndex:(NSInteger)index {
    return 0;//[[self.statsItemData.AllItemData objectAtIndex:index] floatValue];
}

- (float)valueInArray:(int) arrayIndex ObjectAtIndex:(int)index
{
    ZBStatsItemData *item = [self.itemDataArray objectAtIndex:arrayIndex];
    
    return [[item.dataOfMonth objectAtIndex:index] floatValue];
}


- (UIColor *)colorForItemWithIndex:(int)index
{
    ZBStatsItemData* tempItem = (ZBStatsItemData*)[self.itemDataArray objectAtIndex:index];
    return tempItem.mainColor;
}


- (float)minValueOfGraphType:(GraphType) type
{
    //graphtype
    int endIndex = type;
    float minValue = INFINITY;
    for(int i=0;i<self.itemDataArray.count;i++)
    {
        //每个item中取出极值
        float tempmin=[[self.itemDataArray objectAtIndex:i] minValueStartAt:0 EndAt:endIndex];
        //比较极值
        if(tempmin<minValue)
        {
            minValue=tempmin;
        }
    }
    return minValue;
}
- (float)maxValueOfGraphType:(GraphType) type
{
    int endIndex = type;
    float maxValue = 0;
    
    for(int i=0;i<self.itemDataArray.count;i++)
    {
        float tempMax=[[self.itemDataArray objectAtIndex:i] maxValueStartAt:0 EndAt:endIndex];
        if(tempMax>maxValue)
        {
            maxValue=tempMax;
        }
    }
    return maxValue;
}
#pragma mark - LineGraph Delegate

- (int)numberOfGapsBetweenLabels:(GraphType) type
{
    return type == MonthType ? 6 : 1;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index WithTimeRange:(int) range
{
    int currentTypeOffset = range;
    
    return [self.ArrayOfDates objectAtIndex: currentTypeOffset - (index + 1)];
}


//- (void)didTouchGraphWithClosestIndex:(int)index {
//    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
//    
//    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
//}
//
//- (void)didReleaseGraphWithClosestIndex:(float)index {
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.labelValues.alpha = 0.0;
//        self.labelDates.alpha = 0.0;
//    } completion:^(BOOL finished){
//        
//        self.labelValues.text = [NSString stringWithFormat:@"%i", totalNumber];
//        self.labelDates.text = @"between 2000 and 2010";
//        
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.labelValues.alpha = 1.0;
//            self.labelDates.alpha = 1.0;
//        } completion:nil];
//    }];
//    
//}

#pragma mark - UISegmentedControl event
-(void)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    //NSLog(@"Seg.selectedSegmentIndex:%d",Index);
    GraphType temp = ThreeDayType;
    switch (Index) {
        case 0:
            temp = MonthType;
            break;
        case 1:
            temp = WeekType;
            break;
        case 2:
            temp = ThreeDayType;
            break;
        default:
            break;
    }
    currentType = temp;
    [self setGraphViewActive:currentType];
    
    [self.itemTableView reloadData];

}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //
    [self setExtraCellLineHidden:tableView];
    //[tableView setScrollEnabled:NO];
    //
    return 1;
}

//delete useless lines
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    //[view release];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //use the cell defined in storyboard
    static NSString *CellIdentifier = @"StatsItemTableViewCell";
    
    StatsItemTableViewCell *cell = (StatsItemTableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        //cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StatsItemTableViewCell" owner:self options:nil] lastObject];
    }
    //
    int index=indexPath.row;
    ZBStatsItemData* tempItem = (ZBStatsItemData*)[self.itemDataArray objectAtIndex:index];
    cell.itemName.text = tempItem.itemName;
    [cell setColorForItem: tempItem.mainColor];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%.3f",[self calculateTimeForItem:tempItem.currentSecondTime]/currentType];
    if (index == 0) {
        //set separator line for the first cell
        UIView *separatorline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5 )];
        separatorline.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
        [cell addSubview:separatorline];

    }
    return cell;
}

- (double)calculateTimeForItem:(double)secondTime
{
    double result = secondTime / 3600;
    return result;
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (void)exitButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}




//
//- (IBAction)refresh:(id)sender {
//    [self.ArrayOfValues removeAllObjects];
//    [self.ArrayOfDates removeAllObjects];
//
//    for (int i = 0; i < self.graphObjectIncrement.value; i++) {
//        [self.ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 70000)]]; // Random values for the graph
//        [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
//
//        totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
//    }
//
//    UIColor *color;
//    if (self.graphColorChoice.selectedSegmentIndex == 0) color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
//    else if (self.graphColorChoice.selectedSegmentIndex == 1) color = [UIColor colorWithRed:255.0/255.0 green:187.0/255.0 blue:31.0/255.0 alpha:1.0];
//    else if (self.graphColorChoice.selectedSegmentIndex == 2) color = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
//
//    self.lineGraph.colorTop = color;
//    self.lineGraph.colorBottom = color;
//    self.lineGraph.backgroundColor = color;
//    self.view.tintColor = color;
//    self.labelValues.textColor = color;
//    self.navigationController.navigationBar.tintColor = color;
//
//    [self.lineGraph reloadGraph];
//}


@end
