//
//  StatsViewController.m
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "StatsViewController.h"
#import "StatsItemTableViewCell.h"
@interface StatsViewController ()
{
    //record the current graph type
    //0 - >30  1-> 7 2->3
    int currentType;
    
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
    
    currentType=1;
    //
    [self initSegmentedControl];
    
    //get the data from last view
    //...
    [self initData];
    
    //
    [self initGraphs];
    
}

- (void)initNavigationBar
{
    
}

- (void)initSegmentedControl
{
    self.segmentedControl.selectedSegmentIndex =1;//设置默认选择项索引
    [self.segmentedControl setTitle:@"过去三天" forSegmentAtIndex:2];
}

#pragma mark - graph view
- (void)initData
{
    self.itemDataArray=[[NSMutableArray alloc]init];
    int itemCount=3;
    NSMutableArray *nameArray=[[NSMutableArray alloc]init];
    
    //item name
    for (int i=0; i<itemCount; i++)
    {
        NSString* temp=@"Study";
        NSString* name= [temp stringByAppendingString:[[NSString alloc] initWithFormat:@"%d",i]];
        [nameArray addObject:name];
    }
    
    //item color
    self.colorArray=[[NSMutableArray alloc]init];
    UIColor* tempColor=[UIColor colorWithRed:178/255.0 green:226/255.0 blue:140/255.0 alpha:1.0];
    [self.colorArray addObject:tempColor];
    tempColor=[UIColor colorWithRed:112/255.0 green:175/255.0 blue:215/255.0 alpha:1.0];
    [self.colorArray addObject:tempColor];
    tempColor=[UIColor colorWithRed:251/255.0 green:170/255.0 blue:121/255.0 alpha:1.0];
    [self.colorArray addObject:tempColor];
    
    //item data
    for (int i=0; i<itemCount; i++)
    {
        NSMutableArray *tempValues;
        tempValues = [[NSMutableArray alloc] init];
        
        //NSString * nsDateString= [NSString stringWithFormat:@"%d.%d",month,day];
        for(int count=0;count <30;count++)
        {
            [tempValues addObject:[NSNumber numberWithInteger:(arc4random() % 7000)]]; // Random values for the graph
        }
        
        ZBStatsItemData *itemTemp=[[ZBStatsItemData alloc] initWithName:[nameArray objectAtIndex:i] Color:[self.colorArray objectAtIndex:i] AndMouthData:tempValues];
        
        
        [self.itemDataArray addObject:itemTemp];
    }
    
    //7
    self.ArrayOfDates = [[NSMutableArray alloc] init];
    
    NSDate *currentDate=[[NSDate alloc]init];
    NSCalendar * cal=[NSCalendar currentCalendar];
    //currentDate.date
    
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:currentDate];
    //NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    
    
    //
    
    //week
    //TODO: count day for date for display
    for (int i=0; i < 30; i++)
    {
        NSString *tempS=@"";
        if(i==0)
        {
            tempS=@"今日";
        }
        else
        {
            day-=1;
            tempS= [NSString stringWithFormat:@"%d.%d",month,day];
        }
        [self.ArrayOfDates addObject:tempS];
            //[self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i+1]]];
    }
    
}

- (void)initGraphs
{
    //TODO: rewrite this part
    //使数据模型和视图分开
    
    //create view for graph
    self.myGraph = [[StatsLineGraphView alloc] initWithFrame:CGRectMake(-4, 120, 320, 250)];
    
    //self.myGraph.backgroundColor=[UIColor blackColor];
    
    
    self.myGraph.delegate = self;
    
    self.myGraph.itemCount=self.itemDataArray.count;
    
    // Customization of the graph
    self.myGraph.colorTop = [UIColor whiteColor];
    
//    self.myGraph.colorBottom = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:0.5]; // Leaving this not-set on iOS 7 will default to your window's tintColor
//    self.myGraph.colorLine = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:1.0];
    self.myGraph.colorXaxisLabel = [UIColor colorWithRed:99.0/255.0 green:183.0/255.0 blue:170.0/255.0 alpha:1.0];
    self.myGraph.labelFont=[UIFont systemFontOfSize:13];
    self.myGraph.widthLine = 1.5;
    self.myGraph.enableTouchReport = YES;
    self.myGraph.animationGraphEntranceSpeed=0;
    
    //set graph color
    UIColor* tempColor=[UIColor colorWithRed:178/255.0 green:226/255.0 blue:140/255.0 alpha:1.0];
    NSMutableArray* tempArray=[[NSMutableArray alloc] init];
    [tempArray addObject:tempColor];
    tempColor=[UIColor colorWithRed:112/255.0 green:175/255.0 blue:215/255.0 alpha:1.0];
    [tempArray addObject:tempColor];
    tempColor=[UIColor colorWithRed:251/255.0 green:170/255.0 blue:121/255.0 alpha:1.0];
    [tempArray addObject:tempColor];
    self.myGraph.colorsOfGraph=tempArray;
    
    [self.view addSubview:self.myGraph];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    self.myGraph.colorTop = color;
//    self.myGraph.colorBottom = color;
//    self.myGraph.backgroundColor = color;
//    self.view.tintColor = color;
//    self.labelValues.textColor = color;
//    self.navigationController.navigationBar.tintColor = color;
//    
//    [self.myGraph reloadGraph];
//}

#pragma mark - Data Source for graph view

- (int)numberOfXaxisPoints {
    
    //TODO: use graph index to index the generating graph
    
    return 7;//(int)[self.ArrayOfDates count];
}

- (int)numberOfAllPoints{
    return 0;//(int)[self.statsItemData.AllItemData count];
}

- (float)valueForIndex:(NSInteger)index {
    return 0;//[[self.statsItemData.AllItemData objectAtIndex:index] floatValue];
}

- (float)valueInArray:(int) arrayIndex ObjectAtIndex:(int)index
{
    ZBStatsItemData *item=[self.itemDataArray objectAtIndex:arrayIndex];
    
    return [[item.dataOfMonth objectAtIndex:index] floatValue];
}

- (float)minValueOfGraphType:(int) graphIndex
{
    //graphIndex
    //0 -> 30
    //1 -> 7
    //2 -> 3
    int endIndex=0;
    float minValue = INFINITY;
    switch (graphIndex) {
        case 0:
            endIndex=30;
            break;
        case 1:
            endIndex=7;
            break;
        case 2:
            endIndex=3;
            break;
        default:
            break;
    }
    //NSMutableArray *minArray= [[NSMutableArray alloc]init];
    for(int i=0;i<self.itemDataArray.count;i++)
    {
        float tempmin=[[self.itemDataArray objectAtIndex:i] minValueStartAt:0 EndAt:endIndex];
        if(tempmin<minValue)
        {
            minValue=tempmin;
        }
        
    }
    return minValue;
}
- (float)maxValueOfGraphType:(int) graphIndex
{
    
    //graphIndex
    //0 -> 30
    //1 -> 7
    //2 -> 3
    int endIndex=0;
    float maxValue = 0;
    switch (graphIndex) {
        case 0:
            endIndex=30;
            break;
        case 1:
            endIndex=7;
            break;
        case 2:
            endIndex=3;
            break;
        default:
            break;
    }
    //NSMutableArray *minArray= [[NSMutableArray alloc]init];
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
#pragma mark - SimpleLineGraph Delegate

- (int)numberOfGapsBetweenLabels {
    return 1;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index WithTimeRange:(int) range
{
    int currentTypeOffset=range;
    
    return [self.ArrayOfDates objectAtIndex: currentTypeOffset- (index+1)];
    
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
    ZBStatsItemData* tempItem=(ZBStatsItemData*)[self.itemDataArray objectAtIndex:index];
    cell.timeLabel.text=@"2.5";
    cell.itemName.text=tempItem.itemName;
    [cell setColorForItem: tempItem.mainColor];
    
    if (index==0) {
        //create left color block view
        UIView *separatorline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5 )];
        separatorline.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
        [cell addSubview:separatorline];

    }
    
    
    return cell;
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


@end
