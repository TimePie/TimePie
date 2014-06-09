//
//  AboutTimePieViewController.m
//  TimePie
//
//  Created by 大畅 on 14/6/9.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "AboutTimePieViewController.h"
#import "BasicUIColor+UIPosition.h"


@implementation AboutTimePieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"";

    if(isiPhone5){
        UIImageView *mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        mainImage.image = [UIImage imageNamed:@"aboutTimePie"];
        [self.view addSubview:mainImage];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-71, SCREEN_HEIGHT-18, 142, 13)];
        [button setImage:[UIImage imageNamed:@"emailbutton"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(emailto:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }else{
        UIImageView *mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        mainImage.image = [UIImage imageNamed:@"aboutTimePie35"];
        [self.view addSubview:mainImage];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-71, 480-18, 142, 13)];
        [button setImage:[UIImage imageNamed:@"emailbutton"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(emailto:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    
    
    
    }

- (void)emailto:(id)sender
{
    NSString *email = @"mailto:time_pie@yahoo.com?subject=Feedback&body=";
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];

}


@end
