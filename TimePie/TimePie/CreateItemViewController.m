//
//  CreateItemViewController.m
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "CreateItemViewController.h"
#import "BasicUIColor+UIPosition.h"
#import <QuartzCore/QuartzCore.h>
#define TAG_LIMIT_COUNT 200

@interface CreateItemViewController ()

@end

@implementation CreateItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavBar];
    [self initMainVessel];
    [NSTimer scheduledTimerWithTimeInterval:0.033f target:self
                                   selector:@selector(mainLoop:) userInfo:nil repeats:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(respondInput:) withObject:self afterDelay:0.033f];
}

- (void) mainLoop: (id) sender
{
    if(inputField.text.length > 0) initInputLabel.text = @"";
    else initInputLabel.text = @"名称";
    if (tagInputField.text.length > 0) addTagLabel.text = @"";
    else addTagLabel.text = @"新建标签";
    [NSTimer scheduledTimerWithTimeInterval:0.033f target:self
                                   selector:@selector(mainLoop:) userInfo:nil repeats:NO];
}

- (void)respondInput:(id)sender
{
    [inputField becomeFirstResponder];
}

- (void)initNavBar
{
    UIButton *tempBtn_cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 22)];
    [tempBtn_cancel setImage:[UIImage imageNamed:@"CIVC_cancelButton"] forState:UIControlStateNormal];
    [tempBtn_cancel addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:tempBtn_cancel];
    UIButton *tempBtn_confirm = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 22)];
    [tempBtn_confirm setImage:[UIImage imageNamed:@"CIVC_confirmButton"] forState:UIControlStateNormal];
    [tempBtn_confirm addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithCustomView:tempBtn_confirm];
    
    self.title = @"新建事项";
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = confirmButton;
    [self navigationController].navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: MAIN_UI_COLOR};
}

- (void)initMainVessel
{
    _CIVC_mainVessel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _CIVC_mainVessel.separatorInset = UIEdgeInsetsZero;
    _CIVC_mainVessel.dataSource = self;
    _CIVC_mainVessel.delegate = self;
    _CIVC_mainVessel.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    tagTextArray = [[NSMutableArray alloc] initWithObjects:@"工作",@"学习", nil];
    tagCellSelectedFlag = [[NSMutableArray alloc] initWithObjects:@"n",@"n", nil];
    [self.view addSubview:_CIVC_mainVessel];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tagTextArray.count + 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =[NSString stringWithFormat:@"%d",indexPath.row];
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (row == 0)
    {
        if (_itemName.length == 0) [self initTextFieldInView:cell];
    }
    else if(row >= 1 && row <= tagTextArray.count)
    {
        [self initTagCellView:cell withIndexPath:indexPath];
    }
    else if(row == tagTextArray.count + 1)
    {
        [self initAddTagButtonInView:cell];
    }
    else
    {
        [self initRoutineCell:cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >=1 && indexPath.row <= tagTextArray.count)
    {
        UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([[tagCellSelectedFlag objectAtIndex:indexPath.row - 1] isEqualToString:@"y"])
        {
            [tagCellSelectedFlag replaceObjectAtIndex:indexPath.row - 1 withObject:@"n"];
            [self initTagCheckViewInView:cell WithImage:[UIImage imageNamed:@"TagCheckTransparent"] AtIndexPath:indexPath];
        }
        else
        {
            [tagCellSelectedFlag replaceObjectAtIndex:indexPath.row - 1 withObject:@"y"];
            [self initTagCheckViewInView:cell WithImage:[UIImage imageNamed:@"TagCheck"] AtIndexPath:indexPath];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag == 0) _itemName = textField.text;
    else if (textField.text.length > 0)
    {
        [tagTextArray addObject:textField.text];
        [tagCellSelectedFlag addObject:@"n"];
        textField.text = @"";
        [_CIVC_mainVessel reloadData];
    }
    return YES;
}

#pragma mark - target selector
- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonPressed
{
    if (_itemName.length > 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"名称不能为空凸^-^凸" delegate:self cancelButtonTitle:@"我知道错了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)routineButtonPressed:(id)sender
{
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"AddRoutineButtonNormal"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"AddRoutineButtonActive"] forState:UIControlStateSelected];
        [sender setSelected:YES];
    }
}

- (void)addTagButtonPressed:(id)sender
{
    
}

#pragma mark - utilities methods
- (void)initTextFieldInView:(UIView*)view
{
    colorTag = [[UIView alloc] initWithFrame:CGRectMake(10, 14, 20, 20)];
    colorTag.backgroundColor = PINKNO04;
    [self setRoundedView:colorTag toDiameter:16];
    [view addSubview:colorTag];
    inputField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH, 48)];
    inputField.returnKeyType = UIReturnKeyDone;
    inputField.textColor = MAIN_UI_COLOR;
    inputField.tag = 0;
    inputField.delegate = self;
    [view addSubview:inputField];
    initInputLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 120, 48)];
    initInputLabel.text = @"名称";
    initInputLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    [view addSubview:initInputLabel];
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    roundedView.clipsToBounds = YES;
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)initTagCellView:(UIView*)view withIndexPath:(NSIndexPath*)indexPath
{
    if ([view viewWithTag:indexPath.row - 1])
        [[view viewWithTag:indexPath.row - 1] removeFromSuperview];
    UILabel *tempTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 120, 48)];
    tempTagLabel.text = [tagTextArray objectAtIndex:indexPath.row - 1];
    tempTagLabel.tag = indexPath.row - 1;
    [view addSubview:tempTagLabel];
    [tagInputField removeFromSuperview];
    [addTagLabel removeFromSuperview];
}

- (void)initAddTagButtonInView:(UIView*)view
{
    tagInputField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH, 48)];
    tagInputField.returnKeyType = UIReturnKeyDone;
    tagInputField.tag = 1;
    tagInputField.delegate = self;
    addTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 120, 48)];
    addTagLabel.text = @"新建标签";
    addTagLabel.textColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.0];
    [routineButton removeFromSuperview];
    [view addSubview:addTagLabel];
    [view addSubview:tagInputField];
}

- (void)initRoutineCell:(UIView*)view
{
    routineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, -1, SCREEN_WIDTH, 48)];
    [routineButton setImage:[UIImage imageNamed:@"AddRoutineButtonNormal"] forState:UIControlStateNormal];
    [routineButton addTarget:self action:@selector(routineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:routineButton];
}

- (void)initTagCheckViewInView:(UIView*)view WithImage:(UIImage*)image AtIndexPath:(NSIndexPath*)indexPath
{
    if ([view viewWithTag:indexPath.row * TAG_LIMIT_COUNT])
        [[view viewWithTag:indexPath.row * TAG_LIMIT_COUNT] removeFromSuperview];
    tagCheck = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 18)];
    tagCheck.tag = indexPath.row * TAG_LIMIT_COUNT;
    tagCheck.image = image;
    [view addSubview:tagCheck];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
