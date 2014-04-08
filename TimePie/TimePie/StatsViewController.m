//
//  StatsViewController.m
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

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
    // Do any additional setup after loading the view from its nib.
    
    //get the data from last view
    //...
    
    
    self.statsItemData= [[ZBStatsDataArray alloc] initWithCount:3];
    
    self.ArrayOfDates = [[NSMutableArray alloc] init];
    //week
    for (int i=0; i < 7; i++)
    {
        [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i+1]]];
    }
    
    for(int count=0;count <self.statsItemData.itemCount;count++)
    {
        self.ArrayOfValues = [[NSMutableArray alloc] init];
        for (int i=0; i < 7; i++)
        {
            [self.ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 7000)]]; // Random values for the graph
            
        }
        [self.statsItemData.itemDataArrayList addObject:self.ArrayOfValues];
    }
    
    [self.statsItemData initAllIntemData];
    
    [self.statsItemData.itemNameList addObject:@"学习"];
    [self.statsItemData.itemNameList addObject:@"健身"];
    [self.statsItemData.itemNameList addObject:@"酱油"];
    
    //create view for graph
    self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 80, 318, 250)];
    self.myGraph.delegate = self;
    
    self.myGraph.itemCount=self.statsItemData.itemCount;
    
    // Customization of the graph
    self.myGraph.colorTop = [UIColor whiteColor];
    
    self.myGraph.colorBottom = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:0.5]; // Leaving this not-set on iOS 7 will default to your window's tintColor
    self.myGraph.colorLine = [UIColor colorWithRed:251.0/255.0 green:170.0/255.0 blue:121.0/255.0 alpha:1.0];
    self.myGraph.colorXaxisLabel = [UIColor colorWithRed:99.0/255.0 green:183.0/255.0 blue:170.0/255.0 alpha:1.0];

    self.myGraph.widthLine = 2.0;
    self.myGraph.enableTouchReport = YES;
    self.myGraph.animationGraphEntranceSpeed=0;
    
    
    //set graph color
    UIColor* tempColor=[UIColor colorWithRed:177/255.0 green:226/255.0 blue:139/255 alpha:1.0];
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

#pragma mark - Data Source

- (int)numberOfXaxisPoints {
    return (int)[self.ArrayOfDates count];
}

- (int)numberOfAllPoints{
    return (int)[self.statsItemData.AllItemData count];
}

- (float)valueForIndex:(NSInteger)index {
    return [[self.statsItemData.AllItemData objectAtIndex:index] floatValue];
}

- (float)valueInArray:(int) arrayIndex ObjectAtIndex:(int)index
{
    return [[[self.statsItemData.itemDataArrayList objectAtIndex:arrayIndex] objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (int)numberOfGapsBetweenLabels {
    return 1;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index {
    return [self.ArrayOfDates objectAtIndex:index];
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


@end
