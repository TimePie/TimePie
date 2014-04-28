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
#import "BasicUIColor+UIPosition.h"

#import "TimingItem.h"
#import "TimePieTableViewCell.h"

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
    NSLog(@"viewDisLoad");
    
    UINib *nib = [UINib nibWithNibName:@"TimePieTableViewCell" bundle:nil];
    [itemTable registerNib:nib forCellReuseIdentifier:@"TimePieTableViewCell"];
    
    
    if(self){
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"TimePie"];
        
        
        UIBarButtonItem *bbi= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        [n setRightBarButtonItem: bbi];
        
        UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItems:)];
        [n setLeftBarButtonItem:bbiLeft];
                                    
    }
    
    
    
    TimingItem *item1 = [[TimingItem alloc] initWithItemName:@"item1"];
    TimingItem *item2 = [[TimingItem alloc] initWithItemName:@"item2"];
    
    
    items = [[NSArray alloc] initWithObjects:item1,item2, nil];
    
    pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
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
    
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    [[self view] addSubview:pieChart];
    
    
    [pieChart reloadData];
    itemTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 350, 320, 320)];
    itemTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    itemTable.delegate = self;
    itemTable.dataSource = self;
    NSLog(@"before reloadData");
    [itemTable reloadData];
    [[self view] insertSubview:itemTable atIndex:0];
    NSLog(@"After reloadData");
    
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// for pie chart
//////////////////
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    NSLog(@"%lu",[items count]);
    return 2;
}



- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    TimingItem * item = [items objectAtIndex:index];
    return @"item name";
    if(item){
        
        return [item itemName];
    }
    NSLog(@"no item!");
    return nil;
}


- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index;
{
    NSLog(@"lalal");
    return 10;
}


- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    
    return [UIColor blackColor];
}
//////////////////



//for table view
////////////////////
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TimePieTableViewCell * cell=  [tableView dequeueReusableCellWithIdentifier:@"TimePieTableViewCell"];
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell.textLabel setText:@"ItemNuma"];
 //   [cell.itemName setText:@"Item Name"];
 //   [cell.itemTime setText:@"1234:234"];
    //[cell.itemColor setBackgroundColor:[UIColor blackColor]];
    return cell;
    
}
////////////////////

-(IBAction)personal_btn_clicked:(id)sender
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

-(IBAction)create_btn_clicked:(id)sender
{
    CreateItemViewController *viewController = [[CreateItemViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}



-(void)addNewItem:(id)sender{
    NSLog(@"Add new Item");
    CreateItemViewController *viewController = [[CreateItemViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}


-(void)editItems:(id)sender{
    NSLog(@"Edit items");
}

@end
