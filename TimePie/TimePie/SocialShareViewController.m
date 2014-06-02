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

#define weixin_scene_pengyouquan 1
#define weixin_scene_liaotian 0

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
     _WeiboviewController = [[WeiboViewController alloc] init];
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
    BOOL is_installed=[WeiboSDK isWeiboAppInstalled];
    if(is_installed){
        NSLog(@"installed");
        [self ShareWBMessage_installed];
    }
    else{
        NSLog(@"uninstalled");
        NSURL *url = [NSURL URLWithString:@"https://open.weibo.cn/oauth2/authorize?client_id=1524504959&redirect_uri=https://api.weibo.com/oauth2/default.html&display=mobile"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self presentViewController:_WeiboviewController animated:YES completion:nil];
        [_WeiboviewController authorize:request image:_pieChartImage.image text:@"分享内容"];
    }
    NSLog(@"Go to weibo view");
    
    
}

- (void)ShareWBMessage_installed
{
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:@"分享内容" image:_pieChartImage.image]];
    request.userInfo = @{@"ShareMessageFrom": @"SocialShareViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
     
}

- (WBMessageObject *)messageToShare:(NSString *)txt image:(UIImage *)img
{
    WBMessageObject *message = [WBMessageObject message];
    if(txt!=nil){
        message.text = txt;
    }
    if(img!=nil){
        WBImageObject *image = [WBImageObject object];
        image.imageData =UIImagePNGRepresentation(img);
        message.imageObject = image;
    }
    return message;
}



- (void)wechatButtonPressed:(id)sender
{
    [self sendContent:@"Time Pie Shared" image:_pieChartImage.image];
}


- (void) sendContent:(NSString *)text image:(UIImage *)img
{
    if(text!=nil){
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = @"Test Text";
        req.bText = YES;
        req.scene = weixin_scene_pengyouquan;
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
        req1.scene = weixin_scene_pengyouquan;
        
        [WXApi sendReq:req1];
    }
    
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
