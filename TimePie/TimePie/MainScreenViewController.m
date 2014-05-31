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


#define ContentOffsetY -370
#define ContentTriggerOffsetY -560
#define HeightOfItemTable 570
#define ItemTableInitOffsetY -0
#define PieChartInitOffsetY -350

#define ContentOffsetYForAnimation -504

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
    [timingItemStore restoreData];
    modalCanBeTriggered = true;
    NSLog(@"view did appear");
    [[TimingItemStore timingItemStore] addTag:@"学习"];
    [[TimingItemStore timingItemStore] addTag:@"工作"];
    
//    NSLog(@"gettotalhoursbystartdate:%@",[timingItemStore getTotalHoursByStartDate:[NSDate date]]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    modalCanBeTriggered = true;
    
    
    
    if(self){
        
        
        
        
        //setup navigation items
        UINavigationItem *n = [self navigationItem];
        
//        UIImage *image = [UIImage imageNamed:@"TimePie_Nav_Logo.png"];
//        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
        
        [n setTitle:@"TimePie"];
        
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          MAIN_UI_COLOR,
          NSForegroundColorAttributeName,
//          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
//          UITextAttributeTextShadowColor,
//          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
//          UITextAttributeTextShadowOffset,
          [UIFont fontWithName:@"Ubuntu" size:18.0],
          NSFontAttributeName,
          nil]];
        
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
//        [timingItemStore restoreData];
        
        // for test:
//        TimingItem * item = [timingItemStore createItem];
//        [timingItemStore addTag:item TagName:@"hahah"];
//        [timingItemStore getTimingItemsByTagName:@"hahah"];
        
        //setup pieChart
        pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(0, PieChartInitOffsetY, 300, 300)];
        [pieChart setDataSource:self];
        [pieChart setDelegate:self];
        [pieChart setStartPieAngle:M_PI_2];
        [pieChart setLabelFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16]];
        [pieChart setLabelRadius:100];
        [pieChart setShowPercentage:NO];
        [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [pieChart setPieCenter:CGPointMake(160, 160)];
        [pieChart setUserInteractionEnabled:YES];
        [pieChart setLabelShadowColor:[UIColor blackColor]];
        
        
        
        UILongPressGestureRecognizer *longRecognizer=  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPie:)];
        
        [pieChart addGestureRecognizer:longRecognizer];
        
        
        UIImage* bg = [UIImage imageNamed:@"TimePie_RingBG2"];
        UIImageView* bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 320, 311)];
        [bgview setImage:bg];
        [pieChart addSubview:bgview];
        [pieChart sendSubviewToBack:bgview];
//        [itemTable addSubview:bgview];
        
        
        
        
        
        
        //[[self view] addSubview:pieChart];
        
        [pieChart reloadData];
        itemTable = [[MainScreenTableView alloc] initWithFrame:CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable)];
        itemTable.delegate = self;
        itemTable.dataSource = self;
        [itemTable setSeparatorInset:UIEdgeInsetsZero];
//        itemTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        [itemTable reloadData];
        [itemTable setContentInset:UIEdgeInsetsMake(-ContentOffsetY, 0, 0, 0)];
        [itemTable addSubview:pieChart];
        [[self view] insertSubview:itemTable atIndex:0];
        /////////////////////////////////
        
//        selectView = [[SelectView alloc] initWithFrame:CGRectMake(-125, -75, 100, 100)];
//        
//        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
//        tapRecognizer.numberOfTapsRequired =1;
//        [selectView addGestureRecognizer:tapRecognizer];
        
        
//        [[self view] addSubview:selectView];
//        [self showSelectView];
//        [self removeSelectView];
//        UITapGestureRecognizer *singleFingerTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//        [itemTable addGestureRecognizer:singleFingerTap];
        
        
//        [singleFingerTap release];
        

        
        [historyBtn setBackgroundImage:[UIImage imageNamed:@"History_btn"] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"Cancel_btn"] forState:UIControlStateNormal];
        [historyBtn setTitle:@"" forState:UIControlStateNormal];
        [cancelBtn setTitle:@"" forState:UIControlStateNormal];
        historyBtn.hidden = YES;
        cancelBtn.hidden = YES;
        
        //setup timer
        if(timer == nil){
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
        }
        //////////
        
        
        
        
        //main Loop
        NSTimer *runLoopTimer = [NSTimer timerWithTimeInterval:0.04f target:self selector:@selector(mainLoop:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:runLoopTimer forMode:NSRunLoopCommonModes];
        
        
        selectMode = NO;
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
        if(itemTable.contentOffset.y < ContentOffsetYForAnimation)
        {
            [self navigationController].navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44 - (-ContentOffsetYForAnimation + itemTable.contentOffset.y) * .5f);
        }
        if (itemTable.contentOffset.y < ContentTriggerOffsetY && modalCanBeTriggered == true)
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
        
        if(selectMode){
            if([selectedArray containsObject:[[timingItemStore allItems] objectAtIndex:index]]){
                return [[ColorThemes colorThemes] getColorAt:item.color];
            }
            return [[ColorThemes colorThemes] getLightColorAt:item.color];
            
        }else{
            return [[ColorThemes colorThemes] getColorAt:item.color];
        }
    }
    return [UIColor blackColor];
}




- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    if(selectMode){
        NSLog(@"did select slice at index: %d", index);
        TimingItem* item =[[timingItemStore allItems] objectAtIndex:index];
        if(![selectedArray containsObject:item]){
            [selectedArray addObject:item];
        }else{
            [selectedArray removeObject:item];
            NSLog(@"Deselect");
        }
        [pieChart reloadData];
    }
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    if(selectMode){
        NSLog(@"did deselect slice at index: %d", index);
    }
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
    
    
    UIColor* color = [[ColorThemes colorThemes] getColorAt:item.color];
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
    [color getRed:&r green:&g blue:&b  alpha:&a];
    color= [[UIColor alloc] initWithRed:r green:g  blue:b  alpha:1-.1f*indexPath.row];
    cell.itemColor.backgroundColor = color;
    
    cell.itemNotice.backgroundColor =[[ColorThemes colorThemes] getLightColorAt:item.color];
    cell.itemNotice.hidden = YES;
    
    

    /*
    NSString *str = cell.itemName.text;
    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    BOOL valid = [[str stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
    if(valid){
        NSLog(@"alphaset");
        cell.itemName.font = [UIFont fontWithName:@"Roboto-Medium" size:16];
    }else{
        NSLog(@"not alphaset");
        cell.itemName.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    }*/
    cell.itemName.font = [UIFont fontWithName:@"Roboto-Medium" size:16];
    cell.itemTime.font = [UIFont fontWithName:@"Roboto-Condensed" size:14];
    
    cell.itemName.shadowColor = nil;
    cell.itemName.shadowOffset =CGSizeMake(0.0, 1.0);
    cell.itemName.layer.shadowOpacity = 0.0f;
    cell.itemName.layer.shadowRadius = 2.0;
    
    cell.itemTime.shadowColor = nil;
    cell.itemTime.layer.shadowOffset =CGSizeMake(0.0, 1.0);
    cell.itemTime.layer.shadowOpacity = 0.0f;
    cell.itemTime.layer.shadowRadius = 2.0;
    if(indexPath.row ==0){
        UIColor* bgColor = [[ColorThemes colorThemes] getLightColorAt:item.color];
        CGFloat r;
        CGFloat g;
        CGFloat b;
        CGFloat a;
        [bgColor getRed:&r green:&g blue:&b  alpha:&a];
        bgColor= [[UIColor alloc] initWithRed:r green:g  blue:b  alpha:.4];
        
        cell.backgroundColor =bgColor;
        [cell.itemName setTextColor:[UIColor whiteColor]];
        [cell.itemTime setTextColor:[UIColor whiteColor]];
        
//        cell.itemName.shadowColor = [UIColor grayColor];
        cell.itemName.layer.shadowOffset =CGSizeMake(0.0, 1.0);
        cell.itemName.layer.shadowOpacity = .2f;
        cell.itemName.layer.shadowRadius = 2.0f;
        
//        cell.itemTime.shadowColor = [UIColor grayColor];
        cell.itemTime.layer.shadowOffset =CGSizeMake(0.0, 1.0);
        cell.itemTime.layer.shadowOpacity = .2f;
        cell.itemTime.layer.shadowRadius = 2.0f;
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        TimingItem* i = [[timingItemStore allItems] objectAtIndex:0];
        
        UIColor* nameColor = [[ColorThemes colorThemes] getColorAt:i.color];
        CGFloat r;
        CGFloat g;
        CGFloat b;
        CGFloat a;
        [nameColor getRed:&r green:&g blue:&b  alpha:&a];
        nameColor= [[UIColor alloc] initWithRed:r green:g  blue:b  alpha:.7-.06f*indexPath.row];
        

        [cell.itemName setTextColor:nameColor];
        [cell.itemTime setTextColor:MAIN_UI_COLOR_TIME];
//        cell.itemTime.hidden = YES;
    }
    
    
    if(selectMode)
    {
        cell.alpha = .5;
        cell.itemColor.alpha = .5;
        cell.itemNotice.alpha = .5;
        cell.itemTime.alpha =.5;
        cell.itemName.alpha =.5;
    }else{
        cell.alpha =1;
        cell.itemColor.alpha =1;
        cell.itemNotice.alpha =1;
        cell.itemTime.alpha = 1;
        cell.itemName.alpha = 1;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
//    NSDate *start = [NSDate date];

    
    
    
    if(selectMode){
        return ;
    }
        
        
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
    [itemTable reloadData];
    [pieChart reloadData];
    
    
    
//    NSDate *methodFinish = [NSDate date];
//    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
//    NSLog(@"execution time:%f",executionTime);
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
    [[TimingItemStore timingItemStore] saveData];
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


-(IBAction)hist_btn_clicked:(id)sender
{
    if(selectMode){
        
        // delivery data to the history screen;
        if(selectedArray.count != 0)
        {
            //selected items
            StatsViewController *viewController = [[StatsViewController alloc] init];
            viewController.timingItemArray = selectedArray;
            [self presentViewController:viewController animated:YES completion:nil];
            
            //Go back
            pieChart.frame= CGRectMake(0, PieChartInitOffsetY, 300, 300);
            itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable);
            itemTable.scrollEnabled = YES;
            selectMode =NO;
            historyBtn.hidden = YES;
            cancelBtn.hidden = YES;
            
            historyBtn.frame = CGRectMake(historyBtn.frame.origin.x, 1000  , historyBtn.frame.size.width,historyBtn.frame.size.height);
            cancelBtn.frame =CGRectMake(cancelBtn.frame.origin.x, 1000, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
            
            
            [pieChart reloadData];
            selectedArray = nil;

        }
        else
        {
            //select nothing
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择事项" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
            }
    
    
        NSLog(@"history button clicked");
}


-(IBAction)canc_btn_clicked:(id)sender
{
    if(selectMode){
        
        //Go back
        
        pieChart.frame= CGRectMake(0, PieChartInitOffsetY, 300, 300);
        itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable);
        itemTable.scrollEnabled =YES;
        selectMode =NO;
        historyBtn.hidden = YES;
        cancelBtn.hidden = YES;
        
        historyBtn.frame = CGRectMake(historyBtn.frame.origin.x, 1000, historyBtn.frame.size.width,historyBtn.frame.size.height);
        cancelBtn.frame =CGRectMake(cancelBtn.frame.origin.x, 1000, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
        
        [pieChart reloadData];
        selectedArray = nil;
        [itemTable reloadData];
    }
    
    NSLog(@"cancel button clicked");
}





- (void)respondsToTap:(UITapGestureRecognizer *)recognizer {
//    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    
    NSLog(@"Single tap!%@", recognizer);
    
    //Do stuff here...
}


- (void)longPressPie:(UITapGestureRecognizer *)recognizer {
    //    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if(selectMode){
//        selectMode = NO;
//        [pieChart reloadData];
    }else{
        [itemTable setContentOffset:CGPointMake(itemTable.contentOffset.x, ContentOffsetYForAnimation)];
//        NSLog(@"%f",itemTable.contentOffset.y);
        itemTable.scrollEnabled = NO;
        //Enter Select Mode
        NSLog(@"long press!");
        selectMode = YES;
        historyBtn.hidden = NO;
        cancelBtn.hidden = NO;
        historyBtn.frame = CGRectMake(historyBtn.frame.origin.x, 150, historyBtn.frame.size.width,historyBtn.frame.size.height);
        cancelBtn.frame =CGRectMake(cancelBtn.frame.origin.x, 150, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
        
        
        pieChart.frame= CGRectMake(0, PieChartInitOffsetY-35, 300, 300);
        itemTable.frame = CGRectMake(0, ItemTableInitOffsetY+35, 320, 620);
        [pieChart reloadData];
        [itemTable reloadData];
        
        
        selectedArray = [[NSMutableArray alloc] init];
    }
}


/////


//timer Handler
//////////////////
-(void)pollTime
{
    
    NSDate *start = [NSDate date];
    
    
    if([timingItemStore allItems]==nil||[[timingItemStore allItems] count]==0){
        return ;
    }
    
    TimingItem* item = [timingItemStore getItemAtIndex:0];
    
    if([DateHelper checkAcrossDay])
    {
        //across a day
        [timingItemStore restoreData];
//        [Output println:@"Across"];
    }
    else{
        //not across a day
//        [Output println:@"Not across"];
    }
    
    
    
    
    [item check:YES];
    
//    if(count++%10==0){
        [pieChart reloadData];
//    }
    
    
    if(![itemTable isEditing]){
        [itemTable reloadData];
    }
    
    
    
    
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
//    NSLog(@"Execution Time: %f", executionTime);

}
//////////////////////

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.mAnimation;
}

@end
