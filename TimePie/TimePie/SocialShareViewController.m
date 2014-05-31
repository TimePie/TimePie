//
//  SocialShareViewController.m
//  TimePie
//
//  Created by 大畅 on 14-5-31.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "SocialShareViewController.h"
#import "BasicUIColor+UIPosition.h"
#import "TimingItemStore.h"
#import "TimingItemEntity.h"
#import "TimingItem1.h"
#import "ColorThemes.h"

@interface SocialShareViewController ()

@end

@implementation SocialShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self readFileFromDocumentary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_pieChartImage)
    {
        _pieChartImage.frame = CGRectMake(35, 35, 250, 250);
        [self.view addSubview:_pieChartImage];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [self initButtons];
    [self getAllItems];
}

- (void)initButtons
{
    UIButton *weiboButton = [[UIButton alloc] initWithFrame:CGRectMake(13, SCREEN_HEIGHT - 54, 93, 41)];
    [weiboButton setImage:[UIImage imageNamed:@"weiboButton"] forState:UIControlStateNormal];
    [weiboButton addTarget:self action:@selector(weiboButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboButton];
    
    UIButton *wechatButton = [[UIButton alloc] initWithFrame:CGRectMake(114, SCREEN_HEIGHT - 54, 93, 41)];
    [wechatButton setImage:[UIImage imageNamed:@"wechatButton"] forState:UIControlStateNormal];
    [wechatButton addTarget:self action:@selector(wechatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(215, SCREEN_HEIGHT - 54, 93, 41)];
    [cancelButton setImage:[UIImage imageNamed:@"cancelShareButton"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)readFileFromDocumentary
{
    _pieChartImage = [[UIImageView alloc] init];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    UIImage *tempImage = [UIImage imageWithContentsOfFile:[basePath stringByAppendingPathComponent:@"sharePieChartPhoto.png"]];
    _pieChartImage.image = tempImage;
}

#pragma mark - draw items

- (void)getAllItems
{
    itemList = [NSMutableArray arrayWithArray:[[TimingItemStore timingItemStore] allItems]];
    for (int i = 0; i < itemList.count; i++)
    {
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 300 + 20 * i, 100, 20)];
        itemLabel.text = [[itemList objectAtIndex:i] itemName];
        itemLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:15.f];
        itemLabel.textColor = [[ColorThemes colorThemes] getColorAt:[[itemList objectAtIndex:i] itemColor]];
        [self.view addSubview:itemLabel];
    }
}

#pragma mark - target selectors

- (void)weiboButtonPressed:(id)sender
{
}

- (void)wechatButtonPressed:(id)sender
{
}

- (void)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
