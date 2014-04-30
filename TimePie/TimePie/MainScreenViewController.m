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
#import "TCell.h"

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
        
        
        
        
        
        UIImage *personalImage = [UIImage imageNamed:@"personalbtn.png"];
        UIButton *personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        personalButton.bounds = CGRectMake( 0, 0, personalImage.size.width, personalImage.size.height );
        [personalButton setImage:personalImage forState:UIControlStateNormal];
        [personalButton addTarget:self action:@selector(personal_btn_clicked:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithCustomView:personalButton];
        
        
        [n setRightBarButtonItem: bbi];
        
        //UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItems:)];
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
    switch(index){
        case 0:
            return REDNO1;
            break;
        case 1:
            return BLUENO2;
            break;
        case 2:
            return GREENNO3;
            break;
        case 3:
            return PINKNO04;
            break;
        default:
            return [UIColor blackColor];
            break;
    }
    
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
    static NSString *CellIdentifier = @"newFriendCell";
    TCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:@"TCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    [cell.itemName setText:@"abs"];
    cell.itemTime.text = @"0.0s";
    cell.itemColor.backgroundColor = [UIColor blackColor];
    cell.itemNotice.backgroundColor = [UIColor redColor];
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



-(void)addNewItem:(id)sender{
    NSLog(@"Add new Item");
    CreateItemViewController *viewController = [[CreateItemViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}


@end
