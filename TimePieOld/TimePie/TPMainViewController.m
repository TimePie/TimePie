//
//  TPMainViewController.m
//  TimePie
//
//  Created by Storm Max on 14-1-9.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import "TPMainViewController.h"
#import "TimingItem.h"
#import "TimeItemBucket.h"
#import "DetailViewController.h"
#import "TryPicChartViewController.h"
#import "InfColorPickerController.h"
#import "TimePieTableCell.h"
#import "HeaderConf.h"

@interface TPMainViewController ()

@end

@implementation TPMainViewController
@synthesize sliceColors;
@synthesize slices;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    timing = false;
    editingMode = NO;
    
//    [[self view] setUserInteractionEnabled:YES];
//    [[self tableView] setUserInteractionEnabled:YES];
    UINib *nib = [UINib nibWithNibName:@"TableCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"TableCell"];
    
    
    

    //TimingItem *item = [[TimeItemBucket timeItemBucket] getItemAtIndex:0];
    //TryPicChartViewController *pieVC= [[TryPicChartViewController alloc] init];
    
    pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(0, -380, 320, 320)];
    //NSLog(@"%@",[[[self view] subviews] objectAtIndex:0]);
    
    
    if (!timer) {
        timer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
        [[[[TimeItemBucket timeItemBucket] allItems] objectAtIndex:0] refreshStartTime:YES];
        
    }
    [self.tableView setContentInset:UIEdgeInsetsMake(300,0,0,0)];
	// Do any additional setup after loading the view.
    
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    for(int i = 0; i < 5; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [slices addObject:one];
    }
    
    [pieChart setDataSource:self];
    [pieChart setStartPieAngle:M_PI_2];
    [pieChart setAnimationSpeed:1.0];
    [pieChart setLabelFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16]];
//    [pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:16]];
    [pieChart setLabelRadius:120];
    [pieChart setShowPercentage:NO];
    [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [pieChart setPieCenter:CGPointMake(160, 240)];
    [pieChart setUserInteractionEnabled:YES];
    [pieChart setLabelShadowColor:[UIColor blackColor]];

    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    
    [[self view] addSubview:pieChart];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [pieChart reloadData];
    [[self tableView] reloadData];
}


/////for pie chart

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [[[TimeItemBucket timeItemBucket] allItems] count];
//    return self.slices.count;
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    
    TimingItem * item =[[[TimeItemBucket timeItemBucket] allItems] objectAtIndex:index];
    if(item){
        double time = [item time]-28800;////////////////////=
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        if(time<3600-28800){
            [formatter setDateFormat:@"mm:ss"];
        }else{
            [formatter setDateFormat:@"HH:mm"];
        }
        NSString *dateString = [formatter stringFromDate:date];

        return [[NSString alloc] initWithFormat:@"%@  %@",[item itemName],dateString];
    }else{
        return nil;
    }
//    return [[self.slices objectAtIndex:index] intValue];
}


- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index;
{
    TimingItem * item =[[[TimeItemBucket timeItemBucket] allItems] objectAtIndex:index];
    if(item){
        double time = [item time];
        //NSLog(@"%f",time);
        return time;
    }else{
        return 0;
    }
}



- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
//    return nil;
    return [[[TimeItemBucket timeItemBucket] getItemAtIndex:index] color];
    
//    return nil;
//    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}



/////



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self){
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"TimePie"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        [[self navigationItem] setRightBarButtonItem: bbi];
        
        UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItems:)];
        [[self navigationItem] setLeftBarButtonItem:bbiLeft];
        
//        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    
    return self;
}




- (void)pollTime
{
    //NSLog(@"Timer!!");
    TimingItem *item = [[TimeItemBucket timeItemBucket] getItemAtIndex:0];
    if(!item){
        return ;
    }
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    double intervalTime = [localeDate timeIntervalSinceReferenceDate]-[[item startDate] timeIntervalSinceReferenceDate];
    [item setTime:[item oldTime]+intervalTime];
    
    
    
    
    if(![self isEditing]){
        [[self tableView] reloadData];
    }
    [pieChart reloadData];
    
    
    /*
    long lTime = fabs((long)intervalTime);
    NSInteger iSeconds =  lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = fabs(lTime/3600);
    NSInteger iDays = lTime/60/60/24;
    NSInteger iMonth =lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/384;
    */
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"%@",touch.view.description);
}

- (void)moveTableView:(CGFloat)yNum withTime:(float)time
{
    yNum = yNum - [[self tableView] frame].origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:time];
    [self tableView].transform = CGAffineTransformTranslate([self tableView].transform, 0, yNum);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


- (void)editItems:(id)sender{
    editingMode = YES;
    UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditItems:)];
    [[self navigationItem] setLeftBarButtonItem:bbiLeft];
    
}

- (void)doneEditItems:(id)sender{
    editingMode = NO;
    UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItems:)];
    [[self navigationItem] setLeftBarButtonItem:bbiLeft];
}

- (void)addNewItem:(id)sender{
    NSLog(@"add new item");

    
    
    InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
	
    picker.sourceColor = self.view.backgroundColor;
    [picker setDelegate:self];
    [picker setTitle:@"Add New Item"];
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
    //[view setBackgroundColor:[UIColor blackColor]];
    //[[picker view] addSubview:view];
    
    [picker presentModallyOverViewController: self];
    
    
    /*
    TimingItem *newItem = [[TimeItemBucket timeItemBucket] createItem];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    [detailViewController setItem:newItem];
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
        if (!timer) {
            timer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
        }
    }];
    
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFullScreen];
    [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:navController animated:YES completion:nil];
    
    //int lastRow=[[[TimeItemBucket timeItemBucket] allItems] indexOfObject:newItem];
    //NSIndexPath * ip = [NSIndexPath indexPathForItem:lastRow inSection:0];
    //[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
    */
}

/*
- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
	NSLog(@"%@",picker.resultColor.description);
    
//    self.view.backgroundColor = picker.resultColor;
	
	[self dismissModalViewControllerAnimated: YES];
}
*/


- (void) colorPickerControllerDidFinish:(InfColorPickerController *)picker
                               nameText:(NSString *)name
{
    if(!editingMode){
        NSLog(@"%@",name);
        TimingItem *newItem = [[TimeItemBucket timeItemBucket] createItem];
        [newItem setItemName:name];
        [newItem setColor:picker.resultColor];
        
        if (!timer) {
            timer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
        }
    }
    [self dismissModalViewControllerAnimated: YES];
    [[self tableView] reloadData];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"Will begin dragging");
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    

    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGPoint contentOffset =[[self tableView] contentOffset];
//    if(contentOffset.y <  -400){
//        [self moveTableView:50 withTime:.5];
//        contentOffset.y = -401;
//        [[self tableView] setContentOffset:contentOffset animated:YES];
//    }else if([[self tableView] frame].origin.y>0){
//        [self moveTableView:0 withTime:.5];
//        contentOffset.y = -364;
//        [[self tableView] setContentOffset:contentOffset animated:YES];
//        
//    }
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TimeItemBucket timeItemBucket] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
     */
    
    TimingItem *p = [[[TimeItemBucket timeItemBucket] allItems] objectAtIndex:[indexPath row]];
    
    TimePieTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    [cell.blueBack setAlpha:0];
    
    if([indexPath row]!=0){
        [[cell clockImage] setAlpha:0];
    }else{
        [[cell clockImage] setAlpha:.8];
    }
    
    [[cell nameLabel] setText:[p itemName]];
    [[cell timeLabel] setText:[p getTimeString]];
    [[cell colorView] setBackgroundColor:[p color]];
    //[[cell textLabel] setText:[p description]];
    return cell;
}

- (void)willTransitionToState
{
    NSLog(@"willTransitionToState");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delete Item!");
        TimeItemBucket *tib= [TimeItemBucket timeItemBucket];
        NSArray *items = [tib allItems];
        TimingItem *p = [items objectAtIndex:[indexPath row]];
        [tib removeItem:p];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if([[[TimeItemBucket timeItemBucket] allItems] count] == 0){
            [timer invalidate];
            timer= nil;
        }
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TimingItem *item = [[TimeItemBucket timeItemBucket] getItemAtIndex:[indexPath row]];
    NSLog(@"select row:%@",item.description);
    if(!item){
        return;
    }
    [item refreshStartTime:NO];
    if(editingMode){
        NSLog(@"editing mode tap on item");
        InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
        [picker setDelegate:self];
        [picker setTitle:@"Edit Item"];
        //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
        //[view setBackgroundColor:[UIColor blackColor]];
        //[[picker view] addSubview:view];
        [picker presentModallyOverViewController: self withItem:item];
        
    }else{
        [[TimeItemBucket timeItemBucket] moveItemAtIndex:[indexPath row] toIndex:0];
        [[self tableView] reloadData];
    }
}

@end
