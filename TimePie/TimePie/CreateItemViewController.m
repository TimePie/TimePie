//
//  CreateItemViewController.m
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "CreateItemViewController.h"
#import "BasicUIColor+UIPosition.h"

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

#pragma mark - target selector
- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
