//
//  DetailViewController.m
//  TimePie
//
//  Created by Storm Max on 14-1-10.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import "DetailViewController.h"
#import "TimingItem.h"
#import "TimeItemBucket.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize item;
@synthesize dismissBlock;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
        [[self navigationItem] setRightBarButtonItem:doneItem];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [[self navigationItem] setLeftBarButtonItem:cancelItem];
    }
    return self;
}
- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel: (id)sender
{
    [[TimeItemBucket timeItemBucket] removeItem:item];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [itemName setText:[item itemName]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [item setItemName:[itemName text]];
}


- (void)setItem:(TimingItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}



@end
