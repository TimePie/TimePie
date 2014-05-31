//
//  SocialShareViewController.m
//  TimePie
//
//  Created by 大畅 on 14-5-31.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "SocialShareViewController.h"

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
        _pieChartImage.frame = CGRectMake(0, 0, 320, 300);
        [self.view addSubview:_pieChartImage];
    }
}

- (void)readFileFromDocumentary
{
    _pieChartImage = [[UIImageView alloc] init];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    UIImage *tempImage = [UIImage imageWithContentsOfFile:[basePath stringByAppendingPathComponent:@"sharePieChartPhoto.png"]];
    _pieChartImage.image = tempImage;
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
