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
#import "DateHelper.h"
#import "Output.h"
#import "BasicUIColor+UIPosition.h"

#import "BounceAnimation.h"


@interface MainScreenViewController ()
{
    BOOL modalCanBeTriggered;
}
@end

@implementation MainScreenViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self navigationController].view.backgroundColor = [UIColor whiteColor];
        _mAnimation = [BounceAnimation new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.hidden = NO;
    [self navigationController].navigationBar.hidden = NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [timingItemStore restoreData];
    modalCanBeTriggered = true;
    NSLog(@"view did appear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    modalCanBeTriggered = true;
    
    
    
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
        //[timingItemStore restoreData];
        
        // for test:
//        TimingItem * item = [timingItemStore createItem];
//        [timingItemStore addTag:item TagName:@"hahah"];
//        [timingItemStore getTimingItemsByTagName:@"hahah"];
        
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
        itemTable = [[MainScreenTableView alloc] initWithFrame:CGRectMake(0, -50, 320, 660)];
        itemTable.delegate = self;
        itemTable.dataSource = self;
        [itemTable reloadData];
        [itemTable setContentInset:UIEdgeInsetsMake(370, 0, 0, 0)];
        [itemTable addSubview:pieChart];
        [[self view] insertSubview:itemTable atIndex:0];
        /////////////////////////////////
        
        selectView = [[SelectView alloc] initWithFrame:CGRectMake(-125, -75, 100, 100)];
        
        
//        [[self view] addSubview:selectView];
        [self showSelectView];
//        [self removeSelectView];
//        UITapGestureRecognizer *singleFingerTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//        [itemTable addGestureRecognizer:singleFingerTap];
        
        
//        [singleFingerTap release];
        
        
        
        //setup timer
        if(timer == nil){
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
        }
        //////////
        
        //main Loop
        NSTimer *runLoopTimer = [NSTimer timerWithTimeInterval:0.04f target:self selector:@selector(mainLoop:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:runLoopTimer forMode:NSRunLoopCommonModes];
    }
    
}


- (void)showSelectView
{
    [itemTable addSubview:selectView];
    [itemTable bringSubviewToFront:selectView];
    itemTable.frame = CGRectOffset( itemTable.frame, 0, 75 );
    pieChart.frame = CGRectOffset(  pieChart.frame, 0, -75);
}

- (void)removeSelectView
{
    [selectView removeFromSuperview];
    itemTable.frame = CGRectOffset( itemTable.frame, 0, -75 );
    pieChart.frame = CGRectOffset(  pieChart.frame, 0, 75);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



// main loop
//////////////////
- (void)mainLoop:(id)sender
{
    if (itemTable)
    {
        if(itemTable.contentOffset.y < -434.f)
        {
            [self navigationController].navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44 - (434 + itemTable.contentOffset.y) * .5f);
        }
        if (itemTable.contentOffset.y < -580.f && modalCanBeTriggered == true)
        {
            [self resignFirstResponder];
            [self animateModalView];
        }
    }
}



// for pie chart
//////////////////
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
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
    itemtop.timing=NO;
    [item check:NO];
    item.timing=YES;
    
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


//animations
/////////////////////////
- (void)animateModalView
{
    PersonalViewController *viewController = [[PersonalViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.transitioningDelegate = self;
    [self navigationController].navigationBar.hidden = YES;
    self.view.hidden = YES;
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromBottom;
//    [[self navigationController].view.window.layer addAnimation:transition forKey:nil];

    [self presentViewController: navController animated:YES completion:^{
        modalCanBeTriggered = false;
    }];
}


//event handlers
/////////////////////////
-(void)personal_btn_clicked:(id)sender
{
    [self animateModalView];
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


-(void)viewHistoryButtonPressed:(id)sender
{
    NSLog(@"view history!");
}

-(void)cancelSelectButtonPressed:(id)sender
{
    NSLog(@"cancel select!");
}

/*

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    NSLog(@"Single tap!%@", recognizer);
    //Do stuff here...
}
*/
/////


//timer Handler
//////////////////
-(void)pollTime
{
    //NSLog(@"Timer!");
    if([timingItemStore allItems]==nil||[[timingItemStore allItems] count]==0){
        return ;
    }
    
    TimingItem* item = [timingItemStore getItemAtIndex:0];
    
    
    
    if([DateHelper checkAcrossDay])
    {
        //across a day
        [timingItemStore viewAllItem];
        [timingItemStore restoreData];
        [Output println:@"Across"];
        
        //tests:
        [timingItemStore addTag:item TagName:@"Second Tag"];
        [timingItemStore getTimingItemsByTagName:@"Second Tag"];
        [timingItemStore getAllTags];
    }
    else{
        //not across a day
        [Output println:@"Not across"];
    }
    
    
    [item check:YES];
    [pieChart reloadData];
    if(![itemTable isEditing]){
        [itemTable reloadData];
    }
    
    

}
//////////////////////

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.mAnimation;
}

@end
