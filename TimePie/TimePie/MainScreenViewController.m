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

#import "ColorThemes.h"
#import "DateHelper.h"
#import "Output.h"
#import "BasicUIColor+UIPosition.h"
#import "SocialShareViewController.h"

#import "BounceAnimation.h"

#import "WeiXinHelper.h"
#import "BasicUIColor+UIPosition.h"
#import "Tag.h"

#define ContentOffsetY -370
#define ContentTriggerOffsetY -560


#define HeightOfItemTable 570

#define ItemTableInitOffsetY -0
#define PieChartInitOffsetY -350

#define ContentOffsetYForAnimation -504

@interface MainScreenViewController ()
{
    BOOL modalCanBeTriggered;
    BOOL dateTitleLock;
    BOOL originalTitleLock;
    TimeAdjustView *taView;
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
        dateTitleLock = YES;
        originalTitleLock = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.hidden = NO;
    [self navigationController].navigationBar.hidden = NO;
    
    
}

- (void)pieChartAppear:(NSTimer *)chkTimer {
    NSLog(@"pieChartAppear");
    [UIView animateWithDuration:.15
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         itemTable.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"view will disappear");
    [UIView animateWithDuration:.15
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         itemTable.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [timingItemStore restoreData];
    modalCanBeTriggered = true;
    NSLog(@"view did appear");
    [[TimingItemStore timingItemStore] addTag:@"学习"];
    [[TimingItemStore timingItemStore] addTag:@"工作"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    
    NSTimer * ncTimer = [NSTimer scheduledTimerWithTimeInterval:.3
                                                         target:self
                                                       selector:@selector(pieChartAppear:)
                                                       userInfo:nil
                                                        repeats:NO];
//    [ncTimer fire];
    
    
//    NSLog(@"%@",[[ColorThemes colorThemes] getAvailableColors]);
//    NSLog(@"gettotalhoursbystartdate:%@",[timingItemStore getTotalHoursByStartDate:[NSDate date]]);
//    [timingItemStore deleteAllData];
    
    [itemTable reloadData];
    
    if([[timingItemStore allItems] count]==0){
        [itemTable reloadData];
        [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:.4]];
        personalButton.hidden = YES;
        [itemTable addGestureRecognizer:tapRecognizer];
        self.navigationItem.rightBarButtonItem = nil;
        
    }else{
        [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        personalButton.hidden = NO;
        [itemTable removeGestureRecognizer:tapRecognizer];
        self.navigationItem.rightBarButtonItem = addItemButton;
    }
    
    
    [[self navigationItem] setTitleView:titleOriginalView];
    if (originalTitleLock) {
        titleDateView.alpha = titleOriginalView.alpha = 0.0f;
        [self showOriginalTitle:titleOriginalView];
    }
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
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewItem:)];
        tapRecognizer.numberOfTapsRequired =1;
        
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
        
        addItemButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        UIImage *personalImage = [UIImage imageNamed:@"personalbtn.png"];
        personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        personalButton.bounds = CGRectMake( 0, 0, personalImage.size.width, personalImage.size.height );
        [personalButton setImage:personalImage forState:UIControlStateNormal];
        [personalButton addTarget:self action:@selector(personal_btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* bbileft = [[UIBarButtonItem alloc] initWithCustomView:personalButton];
        
        [n setRightBarButtonItem: addItemButton];
        [n setLeftBarButtonItem: bbileft];
        //[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                 forBarMetrics:UIBarMetricsDefault];
        //self.navigationController.navigationBar.shadowImage = [UIImage new];
        //self.navigationController.navigationBar.translucent = YES;
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
        
        if([[timingItemStore allItems] count]==0){
            [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:.4]];
            personalButton.hidden = YES;
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        }
        [pieChart setPieCenter:CGPointMake(160, 160)];
        [pieChart setUserInteractionEnabled:YES];
        [pieChart setLabelShadowColor:[UIColor blackColor]];
        
        
        
        UILongPressGestureRecognizer *longRecognizer=  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPie:)];
        
        [pieChart addGestureRecognizer:longRecognizer];
        
        
        UIImage* bg = [UIImage imageNamed:@"TimePie_RingBG3.png"];
        UIImageView* bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 320, 311)];
        
//        [bgview addGestureRecognizer:tapRecognizer];
        
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
        itemTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
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
        

        
        [historyBtn setBackgroundImage:[UIImage imageNamed:@"historyButton"] forState:UIControlStateNormal];
        
        
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"TimePie_Index_Share"] forState:UIControlStateNormal];
        [shareBtn removeFromSuperview];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancelButton"] forState:UIControlStateNormal];
        [adjustTimeButton setBackgroundImage:[UIImage imageNamed:@"adjustTimeButton"] forState:UIControlStateNormal];
        [historyBtn setTitle:@"" forState:UIControlStateNormal];
        [shareBtn setTitle:@"" forState:UIControlStateNormal];
        [cancelBtn setTitle:@"" forState:UIControlStateNormal];
        [adjustTimeButton setTitle:@"" forState:UIControlStateNormal];
        shareBtn.hidden = NO;
        historyBtn.hidden = YES;
        cancelBtn.hidden = YES;
        adjustTimeButton.hidden = YES;
        
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
    itemTable.frame = CGRectMake(itemTable.frame.origin.x  , itemTable.frame.origin.y, itemTable.frame.size.width, HeightOfItemTable-150);
    itemTable.frame = CGRectOffset( itemTable.frame, 0, 75 );
    pieChart.frame = CGRectOffset(  pieChart.frame, 0, -75);
    
    
}

- (void)removeSelectView
{
    [selectView removeFromSuperview];
    itemTable.frame = CGRectMake(itemTable.frame.origin.x  , itemTable.frame.origin.y, itemTable.frame.size.width, HeightOfItemTable);
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
                return [[ColorThemes colorThemes] getColorAt:item.itemColor];
            }
            return [[ColorThemes colorThemes] getLightColorAt:item.itemColor];
            
        }else{
            return [[ColorThemes colorThemes] getColorAt:item.itemColor];
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
        [itemTable reloadData];
    }
}
/*- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    if(selectMode){
        NSLog(@"did deselect slice at index: %d", index);
    }
}*/


//////////////////






//for table view
////////////////////
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[timingItemStore allItems] count]==0){
        return 0;
    }else{
        return [[timingItemStore allItems] count]+1;
    }
}






-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier;
    if(indexPath.row==[[timingItemStore allItems] count]){
        CellIdentifier= @"newShareCell";
    }else{
        CellIdentifier = @"newFriendCell";
    }
    TCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:@"TCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    
    if(indexPath.row==[[timingItemStore allItems] count]){
        cell.itemName.hidden = YES;
        cell.itemTime.hidden = YES;
        cell.itemNotice.hidden = YES;
        [shareBtn removeFromSuperview];
        shareBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 47);
        [cell addSubview:shareBtn];
        return cell;
    }else{
        cell.itemTime.hidden = NO;
        cell.itemName.hidden = NO;
        cell.itemNotice.hidden = NO;
    }

    
    TimingItem * item = [[timingItemStore allItems] objectAtIndex:indexPath.row];
    [cell.itemName setText:item.itemName];
    
    cell.itemTime.text = [NSString stringWithFormat:@"%@", [item getTimeString]];
    
    UIColor* color = [[ColorThemes colorThemes] getColorAt:item.itemColor];
//    CGFloat r;
//    CGFloat g;
//    CGFloat b;
//    CGFloat a;
//    [color getRed:&r green:&g blue:&b  alpha:&a];
//    color= [[UIColor alloc] initWithRed:r green:g  blue:b  alpha:1-.1f*indexPath.row];
    cell.itemColor.backgroundColor = color;
    
    cell.itemNotice.backgroundColor =[[ColorThemes colorThemes] getLightColorAt:item.itemColor];
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
        UIColor* bgColor = [[ColorThemes colorThemes] getLightColorAt:item.itemColor];
//        CGFloat r;
//        CGFloat g;
//        CGFloat b;
//        CGFloat a;
//        [bgColor getRed:&r green:&g blue:&b  alpha:&a];
//        bgColor= [[UIColor alloc] initWithRed:r green:g  blue:b  alpha:.4];
        
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
        
        UIColor* nameColor = [[ColorThemes colorThemes] getColorAt:i.itemColor];
//        CGFloat r;
//        CGFloat g;
//        CGFloat b;
//        CGFloat a;
//        [nameColor getRed:&r green:&g blue:&b  alpha:&a];
//        nameColor= [[UIColor alloc] initWithRed:r green:g  blue:b  alpha:.7-.06f*indexPath.row];
        

        [cell.itemName setTextColor:nameColor];
        [cell.itemTime setTextColor:MAIN_UI_COLOR_TIME];
//        cell.itemTime.hidden = YES;
    }
    
    
    if(selectMode&&![selectedArray containsObject:[[timingItemStore allItems] objectAtIndex:indexPath.row]])
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
    
    //utitlity buttons
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
//    NSDate *start = [NSDate date];

    if(indexPath.row == [[timingItemStore allItems] count]){
        [self share_btn_clicked:nil];
        return ;
    }
    
    
    if(selectMode){
        TimingItem *item = [timingItemStore getItemAtIndex:indexPath.row];
        if(![selectedArray containsObject:item]){
            [selectedArray addObject:item];
        }else{
            [selectedArray removeObject:item];
            NSLog(@"Deselect");
        }
        [pieChart reloadData];
        [itemTable reloadData];
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
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        TimingItem *p = [[timingItemStore allItems] objectAtIndex:[indexPath row]];
        [timingItemStore removeItem:p];
        [itemTable reloadData];
        NSLog(p.itemName);
        
        if([[timingItemStore allItems] count] == 0){
            [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:.4]];
            personalButton.hidden = YES;
//            self.navigationItem.rightBarButtonItem = nil;
//            [itemTable addGestureRecognizer:tapRecognizer];
        }
    }
}

//自定义 delete
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    return @"删除";
//}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.76f green:0.73f blue:0.674f alpha:1.0]
                                                title:@"编辑"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.f green:0.584f blue:0.37f alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            {
                NSLog(@"utility buttons closed");
                [itemTable setEditing:NO];
            }
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            {
                NSLog(@"right utility buttons open");
                [itemTable setEditing:YES];
            }
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"Edit Item");
            NSIndexPath *cellIndexPath = [itemTable indexPathForCell:cell];
            TimingItem *p = [[timingItemStore allItems] objectAtIndex:[cellIndexPath row]];
            CreateItemViewController *viewController = [[CreateItemViewController alloc] init];
            viewController.isEditView = YES;
            viewController.editItem = p;
            viewController.editItemName = p.itemName;
            viewController.editItemColor = [[ColorThemes colorThemes] getColorAt:p.itemColor];
            viewController.editItemTag = [[[TimingItemStore timingItemStore] getTagByItem:p.itemName] tag_name];
            viewController.currentTagOfItem = viewController.editItemTag;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [self presentViewController:navController animated:YES completion:nil];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [itemTable indexPathForCell:cell];
            
            TimingItem *p = [[timingItemStore allItems] objectAtIndex:[cellIndexPath row]];
            [timingItemStore removeItem:p];
            [itemTable reloadData];
            NSLog(p.itemName);
            
            if([[timingItemStore allItems] count] == 0){
                [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:.4]];
                personalButton.hidden = YES;
                //            self.navigationItem.rightBarButtonItem = nil;
                //            [itemTable addGestureRecognizer:tapRecognizer];
            }
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
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





-(UIImage *) screenshot
{
    
    CGRect rect;
    rect=CGRectMake(0, 0, 320, 480);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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


-(void)respondsToTap:(id)sender
{
    NSLog(@"%@",sender);
}



-(IBAction)share_btn_clicked:(id)sender
{
    [timingItemStore saveData];
    //    [self sendContent:@"hello" image:[UIImage imageNamed:@"Cancel_btn.png"]];
    
    SocialShareViewController *ssVC = [[SocialShareViewController alloc] init];
    ssVC.pieChartImage.image = [self imageWithView:pieChart];
    [self presentViewController:ssVC animated:YES completion:nil];
    return ;
    
    
    if(selectMode)
    {
    
        // delivery data to the history screen;
        if(selectedArray.count != 0)
        {
            //Go back
            
            pieChart.frame= CGRectMake(0, PieChartInitOffsetY, 300, 300);
            if(isiPhone5){
            itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable);
            }else{
            itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable-75);
            }
            itemTable.scrollEnabled =YES;
            selectMode =NO;
            
            shareBtn.hidden = NO;
            historyBtn.hidden = YES;
            cancelBtn.hidden = YES;
            
            historyBtn.frame = CGRectMake(historyBtn.frame.origin.x, 1000, historyBtn.frame.size.width,historyBtn.frame.size.height);
            shareBtn.frame = CGRectMake(shareBtn.frame.origin.x, 1000, shareBtn.frame.size.width,shareBtn.frame.size.height);
            cancelBtn.frame =CGRectMake(cancelBtn.frame.origin.x, 1000, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
            
            SocialShareViewController *ssVC = [[SocialShareViewController alloc] init];
            ssVC.pieChartImage.image = [self imageWithView:pieChart];
            [self presentViewController:ssVC animated:YES completion:nil];
            
            [pieChart reloadData];
        }
        else
        {
            //select nothing
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择事项" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)addNewItem:(id)sender{
    NSLog(@"Add new Item");
    CreateItemViewController *viewController = [[CreateItemViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
    
    //    SocialShareViewController *ssvc = [[SocialShareViewController alloc] init];
    //    [self presentViewController:ssvc animated:YES completion:nil];
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
    if(selectMode)
    {
        
        // delivery data to the history screen;
        if(selectedArray.count != 0)
        {
            //selected items
            StatsViewController *viewController = [[StatsViewController alloc] init];
            viewController.timingItemArray = selectedArray;
            [self presentViewController:viewController animated:YES completion:nil];
            
            //Go back
            pieChart.frame= CGRectMake(0, PieChartInitOffsetY, 300, 300);
            if(isiPhone5){
            itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable);
            }else{
            itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable-75);
            }
            itemTable.scrollEnabled = YES;
            selectMode =NO;
            
            shareBtn.hidden = NO;
            historyBtn.hidden = YES;
            cancelBtn.hidden = YES;
            adjustTimeButton.hidden = YES;
            
            historyBtn.frame = CGRectMake(historyBtn.frame.origin.x, 1000, historyBtn.frame.size.width,historyBtn.frame.size.height);
            shareBtn.frame = CGRectMake(shareBtn.frame.origin.x, 1000, shareBtn.frame.size.width,shareBtn.frame.size.height);
            cancelBtn.frame =CGRectMake(cancelBtn.frame.origin.x, 1000, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
            adjustTimeButton.frame =CGRectMake(adjustTimeButton.frame.origin.x, 1000, adjustTimeButton.frame.size.width, adjustTimeButton.frame.size.height);
            
            
            [pieChart reloadData];
            selectedArray = nil;
            
        }
        else
        {
            //select nothing
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择要查看历史数据的事项" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    
    NSLog(@"history button clicked");
}

- (IBAction)timeAdjust_btn_clicked:(id)sender
{
    if(selectMode){
        
        //Go back
        if(selectedArray.count == 2)
        {
            [self animateTimeAdjustView];
            
            pieChart.frame= CGRectMake(0, PieChartInitOffsetY, 300, 300);
            if(isiPhone5){
                itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable);
            }else{
                itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable-75);
            }
            itemTable.scrollEnabled =YES;
            selectMode =NO;
            
            shareBtn.hidden = NO;
            historyBtn.hidden = YES;
            cancelBtn.hidden = YES;
            adjustTimeButton.hidden = YES;
            
            historyBtn.frame = CGRectMake(historyBtn.frame.origin.x, 1000, historyBtn.frame.size.width,historyBtn.frame.size.height);
            cancelBtn.frame =CGRectMake(cancelBtn.frame.origin.x, 1000, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
            adjustTimeButton.frame =CGRectMake(adjustTimeButton.frame.origin.x, 1000, adjustTimeButton.frame.size.width, adjustTimeButton.frame.size.height);
            
            [pieChart reloadData];
            [itemTable reloadData];
        }
        else
        {
            //select nothing
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择要调整时间的两个事项" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(IBAction)canc_btn_clicked:(id)sender
{
    if(selectMode){
        
        //Go back
        
        pieChart.frame= CGRectMake(0, PieChartInitOffsetY, 300, 300);
        if(isiPhone5){
        itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable);
        }else{
        itemTable.frame = CGRectMake(0, ItemTableInitOffsetY, 320, HeightOfItemTable-75);
        }
        itemTable.scrollEnabled =YES;
        selectMode =NO;
        
        shareBtn.hidden = NO;
        historyBtn.hidden = YES;
        cancelBtn.hidden = YES;
        adjustTimeButton.hidden = YES;
        
        historyBtn.frame = CGRectMake(historyBtn.frame.origin.x, 1000, historyBtn.frame.size.width,historyBtn.frame.size.height);
        cancelBtn.frame =CGRectMake(cancelBtn.frame.origin.x, 1000, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
        adjustTimeButton.frame =CGRectMake(adjustTimeButton.frame.origin.x, 1000, adjustTimeButton.frame.size.width, adjustTimeButton.frame.size.height);
        
        [pieChart reloadData];
        selectedArray = nil;
        [itemTable reloadData];
    }
    
    NSLog(@"cancel button clicked");
}

- (void)animateTimeAdjustView
{
    if (!taView) {
        taView = [[TimeAdjustView alloc] initWithFrame:CGRectMake(0, 568, SCREEN_WIDTH, 150)];
        [taView.layer setShadowColor:[UIColor blackColor].CGColor];
        [taView.layer setShadowOpacity:0.55];
        [taView.layer setShadowRadius:15.0];
        [taView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        taView.delegate = self;
        [self.view addSubview:taView];
    }
    [self loadTAViewData];
    taView.hidden = NO;
    [self pushAnimateView:taView];
}

- (void)loadTAViewData
{
    taView.lhsItem = (TimingItem*)[selectedArray objectAtIndex:0];
    taView.rhsItem = (TimingItem*)[selectedArray objectAtIndex:1];
    taView.lhsOriginalTime = [(TimingItem*)[selectedArray objectAtIndex:0] time];
    taView.rhsOriginalTime = [(TimingItem*)[selectedArray objectAtIndex:1] time];
    taView.lhsItemView.backgroundColor = [[ColorThemes colorThemes] getColorAt:[(TimingItem*)[selectedArray objectAtIndex:0] itemColor]];
    taView.rhsItemView.backgroundColor = [[ColorThemes colorThemes] getColorAt:[(TimingItem*)[selectedArray objectAtIndex:1] itemColor]];
    taView.lhsItemName.text = [(TimingItem*)[selectedArray objectAtIndex:0] itemName];
    taView.rhsItemName.text = [(TimingItem*)[selectedArray objectAtIndex:1] itemName];
    taView.lhsItemTiming.text = [(TimingItem*)[selectedArray objectAtIndex:0] getTimeString];
    taView.rhsItemTiming.text = [(TimingItem*)[selectedArray objectAtIndex:1] getTimeString];
    taView.lhsItemTiming.textColor = [[ColorThemes colorThemes] getLightColorAt:[(TimingItem*)[selectedArray objectAtIndex:0] itemColor]];
    taView.rhsItemTiming.textColor = [[ColorThemes colorThemes] getLightColorAt:[(TimingItem*)[selectedArray objectAtIndex:1] itemColor]];
    taView.taSlider.maximumValue = taView.lhsOriginalTime + taView.rhsOriginalTime;
    taView.taSlider.value =  taView.taSlider.maximumValue * (taView.lhsOriginalTime / (taView.rhsOriginalTime + taView.lhsOriginalTime));
    taView.taSlider.tintColor = [[ColorThemes colorThemes] getColorAt:[(TimingItem*)[selectedArray objectAtIndex:0] itemColor]];
}

- (void)pushAnimateView:(UIView*)view
{
    if (IS_IPHONE_HIGHERINCHE)
    {
        [UIView animateWithDuration:.25f animations:^{
            view.frame = CGRectMake(0, 418, SCREEN_WIDTH, 150);
        } completion:^(BOOL finished){
            pieChart.userInteractionEnabled = NO;
            itemTable.scrollEnabled = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:.25f animations:^{
            view.frame = CGRectMake(0, 330, SCREEN_WIDTH, 150);
        } completion:^(BOOL finished){
            pieChart.userInteractionEnabled = NO;
            itemTable.scrollEnabled = NO;
        }];
    }
}

#pragma mark - TimeAdjustViewDelegate

- (void)confirmPressedPassWithLhs:(double)lTime Rhs:(double)rTime
{
    if (IS_IPHONE_HIGHERINCHE) {
        [UIView animateWithDuration:.25f animations:^{
            taView.frame = CGRectMake(0, 568, SCREEN_WIDTH, 150);
        } completion:^(BOOL finished){
            [[TimingItemStore timingItemStore] setItemTime:[selectedArray objectAtIndex:0] withTime:lTime];
            [[TimingItemStore timingItemStore] setItemTime:[selectedArray objectAtIndex:1] withTime:rTime];
            selectedArray = nil;
            pieChart.userInteractionEnabled = YES;
            taView.hidden = YES;
            itemTable.scrollEnabled = YES;
        }];
    }
    else{
        [UIView animateWithDuration:.25f animations:^{
            taView.frame = CGRectMake(0, 480, SCREEN_WIDTH, 150);
        } completion:^(BOOL finished){
            [[TimingItemStore timingItemStore] setItemTime:[selectedArray objectAtIndex:0] withTime:lTime];
            [[TimingItemStore timingItemStore] setItemTime:[selectedArray objectAtIndex:1] withTime:rTime];
            selectedArray = nil;
            pieChart.userInteractionEnabled = YES;
            taView.hidden = YES;
            itemTable.scrollEnabled = YES;
        }];
    }
}

- (void)cancelPressedPass
{
    if (IS_IPHONE_HIGHERINCHE) {
        [UIView animateWithDuration:.5f animations:^{
            taView.frame = CGRectMake(0, 568, SCREEN_WIDTH, 150);
        } completion:^(BOOL finished){
            pieChart.userInteractionEnabled = YES;
            taView.hidden = YES;
            itemTable.scrollEnabled = YES;
        }];
    }
    else{
        [UIView animateWithDuration:.5f animations:^{
            taView.frame = CGRectMake(0, 480, SCREEN_WIDTH, 150);
        } completion:^(BOOL finished){
            pieChart.userInteractionEnabled = YES;
            taView.hidden = YES;
            itemTable.scrollEnabled = YES;
        }];
    }
}

- (void)longPressPie:(UITapGestureRecognizer *)recognizer {
    
    //    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if(selectMode||[[timingItemStore allItems] count]==0){
//        selectMode = NO;
//        [pieChart reloadData];
    }else{
        [itemTable setContentOffset:CGPointMake(itemTable.contentOffset.x, ContentOffsetYForAnimation)];
//        NSLog(@"%f",itemTable.contentOffset.y);
//        itemTable.scrollEnabled = NO;
        //Enter Select Mode
        NSLog(@"long press!");
        selectMode = YES;
        shareBtn.hidden = NO;
        historyBtn.hidden = NO;
        cancelBtn.hidden = NO;
        adjustTimeButton.hidden = NO;
        historyBtn.frame = CGRectMake(historyBtn.frame.origin.x, 150, historyBtn.frame.size.width,historyBtn.frame.size.height);
        shareBtn.frame = CGRectMake(shareBtn.frame.origin.x, 150, shareBtn.frame.size.width,shareBtn.frame.size.height);
        cancelBtn.frame =CGRectMake(cancelBtn.frame.origin.x, 150, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
        adjustTimeButton.frame =CGRectMake(adjustTimeButton.frame.origin.x, 150, adjustTimeButton.frame.size.width, adjustTimeButton.frame.size.height);
        
        
        
        pieChart.frame= CGRectMake(0, PieChartInitOffsetY-35, 300, 300);
        itemTable.frame = CGRectMake(0, ItemTableInitOffsetY+35, 320, HeightOfItemTable-27);
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
    
    
    
    
    if([timingItemStore allItems]==nil||[[timingItemStore allItems] count]==0){
        [pieChart reloadData];
        return ;
    }
    
    
    TimingItem* item = [timingItemStore getItemAtIndex:0];
    if(item.timing==NO){
        item.timing = YES;
    }
    if([DateHelper checkAcrossDay])
    {
        //across a day
        [timingItemStore saveData];
        [timingItemStore restoreData];
//        [Output println:@"Across"];
    }
    else{
        //not across a day
//        [Output println:@"Not across"];
    }
    
    if([DateHelper checkIf5760]){
        [pieChart setShowPercentage:YES];
    }else{
        [pieChart setShowPercentage:NO];
    }
    
    titleDateView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    titleOriginalView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    titleDateView.font = titleOriginalView.font = [UIFont fontWithName:@"Ubuntu" size:18.f];
    titleDateView.textColor = titleOriginalView.textColor = MAIN_UI_COLOR;
    titleDateView.text = [DateHelper getDateString];
    titleOriginalView.text = @"TimePie";
    
    if([DateHelper checkIf123]){
        [[self navigationItem] setTitleView:titleDateView];
        if (dateTitleLock) {
            titleDateView.alpha = titleOriginalView.alpha = 0.0f;
            [self showDateTitle:titleDateView];
        }
    }else{
        [[self navigationItem] setTitleView:titleOriginalView];
        if (originalTitleLock) {
            titleDateView.alpha = titleOriginalView.alpha = 0.0f;
            [self showOriginalTitle:titleOriginalView];
        }
    }
    
    [item check:YES];
    
//    if(count++%10==0){
    [pieChart reloadData];
//    }
    
    
    if(![itemTable isEditing]){
        [itemTable reloadData];
    }
    
    

}
//////////////////////




- (void) sendContent:(NSString *)text image:(UIImage *)img
{
    enum WXScene _scene = WXSceneTimeline;
    if(text!=nil){
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = @"Test Text";
        req.bText = YES;
        req.scene = _scene;
        [WXApi sendReq:req];
    }
    if(img!=nil){
        
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:img];
        
        WXImageObject *ext = [WXImageObject object];
        // NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5thumb" ofType:@"png"];
        NSLog(@"here");
        
        
        
        ext.imageData = UIImagePNGRepresentation(img);
        
        //UIImage* image = [UIImage imageWithContentsOfFile:filePath];
        //UIImage* image = [UIImage imageWithData:ext.imageData];
        //ext.imageData = UIImagePNGRepresentation(image);
        
        //    UIImage* image = [UIImage imageNamed:@"res5thumb.png"];
        //    ext.imageData = UIImagePNGRepresentation(image);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req1 = [[SendMessageToWXReq alloc] init];
        req1.bText = NO;
        req1.message = message;
        req1.scene = _scene;
        
        [WXApi sendReq:req1];
    }
    
}












#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.mAnimation;
}

#pragma mark - Utilities Screenshot
- (UIImageView*)takeScreenshotOfPieChartWithFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(frame.size);
    [sourceImage drawAtPoint:frame.origin];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *tempIM = [[UIImageView alloc] initWithImage:croppedImage];
    tempIM.frame = CGRectMake(0, 0, 320, 500);
    
    return tempIM;
}

- (void)saveUIImageAsPNG:(UIImageView*)sourceImageView
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    UIImage * imageToSave = sourceImageView.image;
    NSData * binaryImageData = UIImagePNGRepresentation(imageToSave);
    
    [binaryImageData writeToFile:[basePath stringByAppendingPathComponent:@"sharePieChartPhoto.png"] atomically:YES];
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    
    //fill with white back ground
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 320, 320);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, rect);
    
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Utilities Animation
- (void)showOriginalTitle:(UILabel*)view
{
    [UIView animateWithDuration:.5f animations:^{
        view.alpha = 1.0f;
    } completion:^(BOOL finished){
        originalTitleLock = NO;
        dateTitleLock = YES;
    }];
}

- (void)showDateTitle:(UILabel*)view
{
    [UIView animateWithDuration:.5f animations:^{
        view.alpha = 1.0f;
    } completion:^(BOOL finished){
        dateTitleLock = NO;
        originalTitleLock = YES;
    }];
}

@end
