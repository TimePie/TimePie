//
//  MainScreenViewController.m
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "MainScreenViewController.h"
#import "PersonalViewController.h"
#import "StatsViewController.h"
#import "CreateItemViewController.h"

#import "TimingItem1.h"
#import "TCell.h"
#import "ColorThemes.h"


@interface MainScreenViewController ()

@end

@implementation MainScreenViewController



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
    
    
    
    
    
    
    
    if(self){
        //setup navigation items
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"TimePie"];
        
        
        UIBarButtonItem *bbi= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        UIImage *personalImage = [UIImage imageNamed:@"personalbtn.png"];
        UIButton *personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        personalButton.bounds = CGRectMake( 0, 0, personalImage.size.width, personalImage.size.height );
        [personalButton setImage:personalImage forState:UIControlStateNormal];
        [personalButton addTarget:self action:@selector(personal_btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithCustomView:personalButton];
        
        [n setRightBarButtonItem: bbi];
        [n setLeftBarButtonItem:bbiLeft];
        /////////////////////////////////
        
        
        
        
        
        //setup timingItemStore
        timingItemStore = [TimingItemStore timingItemStore];
        
        
        //[timingItemStore getToday];
        
        
        //test items
        /*
        TimingItem *item1 = [timingItemStore createItem];
        TimingItem *item2 = [timingItemStore createItem];
        
        
        item1.itemName = @"item1";
        item2.itemName = @"item2";
        item1.time = 0;
        item2.time = 0;
        */
        ////////////////////////////////
        
        
//        [timingItemStore deletaAllItem];
//        [timingItemStore saveData];
        [timingItemStore restoreData];
//        [timingItemStore viewAllItem];
        
        
        
        
        
        
        //setup pieChart
        pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(0, -390, 300, 300)];
        [pieChart setDataSource:self];
        [pieChart setDelegate:self];
        [pieChart setStartPieAngle:M_PI_2];
        [pieChart setLabelFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16]];
        [pieChart setLabelRadius:100];
        [pieChart setShowPercentage:NO];
        [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [pieChart setPieCenter:CGPointMake(160, 240)];
        [pieChart setUserInteractionEnabled:YES];
        [pieChart setLabelShadowColor:[UIColor blackColor]];
        
        //[[self view] addSubview:pieChart];
        
        [pieChart reloadData];
        itemTable = [[MainScreenTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 560)];
        itemTable.delegate = self;
        itemTable.dataSource = self;
        [itemTable reloadData];
        [itemTable setContentInset:UIEdgeInsetsMake(320, 0, 0, 0)];
        [itemTable addSubview:pieChart];
        [[self view] insertSubview:itemTable atIndex:0];
        /////////////////////////////////
        
        
        //setup timer
        if(timer == nil){
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
        }
        //////////
        
        
        
        
        
    }
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}












// for pie chart
//////////////////
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    //NSLog(@"%lu",(unsigned long)[[timingItemStore allItems] count]);
    return [[timingItemStore allItems] count];
}



- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    TimingItem * item = [[timingItemStore allItems] objectAtIndex:index];
    if(item){
        return [NSString stringWithFormat:@"%@\n%@",[item itemName], [item getTimeString]];
    }
    NSLog(@"no item!");
    return nil;
}


- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index;
{
    
    TimingItem * item = [[timingItemStore allItems] objectAtIndex:index];
    if(item){
        return [item time];
    }
    return 0;
}


- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    TimingItem * item = [[timingItemStore allItems] objectAtIndex:index];
    if(item){
        return [[ColorThemes colorThemes] getColorAt:item.color];
    }
    return [UIColor blackColor];
}
//////////////////






//for table view
////////////////////
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[timingItemStore allItems] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    TCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:@"TCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    TimingItem * item = [[timingItemStore allItems] objectAtIndex:indexPath.row];
    [cell.itemName setText:item.itemName];
    
    cell.itemTime.text = [NSString stringWithFormat:@"%@", [item getTimeString]];
    
    cell.itemColor.backgroundColor = [[ColorThemes colorThemes] getColorAt:item.color];
    cell.itemNotice.backgroundColor =[[ColorThemes colorThemes] getLightColorAt:item.color];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Timer!");
    if([timingItemStore allItems]==nil||[[timingItemStore allItems] count]==0){
        return ;
    }
    
    TimingItem *item = [timingItemStore getItemAtIndex:[indexPath row]];
    if(!item){
        return ;
    }
    TimingItem *itemtop = [timingItemStore getItemAtIndex:0];
    if(!item){
        return ;
    }
    if(itemtop==item){
        return;
    }
    [itemtop check:YES];
    itemtop.active=NO;
    [item check:NO];
    item.active=YES;
    
    [timingItemStore moveItemAtIndex:[indexPath row] toIndex:0];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        TimingItem *p = [[timingItemStore allItems] objectAtIndex:[indexPath row]];
        [timingItemStore removeItem:p];
        [itemTable reloadData];
        NSLog(p.itemName);
    }
}
////////////////////





//event handlers
/////////////////////////
-(void)personal_btn_clicked:(id)sender
{
    PersonalViewController *viewController = [[PersonalViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];    
    [self presentViewController: navController animated:YES completion:nil];
}

- (void)settingsButtonPressed
{
}

-(IBAction)stats_btn_clicked:(id)sender
{
    StatsViewController *viewController = [[StatsViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    NSLog(@"Go to statistics view");
}

-(void)addNewItem:(id)sender{
    NSLog(@"Add new Item");
    CreateItemViewController *viewController = [[CreateItemViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}


-(void)pollTime
{
    //NSLog(@"Timer!");
    if([timingItemStore allItems]==nil||[[timingItemStore allItems] count]==0){
        return ;
    }
    
    TimingItem* item = [timingItemStore getItemAtIndex:0];
    
    /*
    if(item.time >=10&& item.time<11){
        [timingItemStore createItem:item];
        [timingItemStore saveData];
        [timingItemStore restoreData];
    }
    */
    
    [item check:YES];
    [pieChart reloadData];
    if(![itemTable isEditing]){
        [itemTable reloadData];
    }
    
    

}
//////////////////////


@end
