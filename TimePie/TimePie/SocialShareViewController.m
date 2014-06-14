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
#import "RingCircle.h"
#import "SharingTimingItemView.h"
#import "DateHelper.h"
#import <QuartzCore/QuartzCore.h>



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




- (void)pieChartAppear:(NSTimer *)chkTimer {
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    contentView = [[UIView alloc] init];
    [self.view addSubview:scroll];
    [scroll addSubview:contentView];
    //        [self.view addSubview:_pieChartImage];
    timePieLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 300, 50)];
    timePieLabel.text = @"TimePie";
    timePieLabel.font = [UIFont fontWithName:@"Ubuntu" size:28.f];
    timePieLabel.textColor = SHARING_TITLE_COLOR;
    timePieLabel.layer.shadowColor = [SHARING_TITLE_COLOR CGColor];
    timePieLabel.layer.shadowRadius = 3;
    timePieLabel.layer.shadowOpacity =.4;
    timePieLabel.layer.shadowOffset = CGSizeMake(0, 0);
    [contentView addSubview:timePieLabel];
    
    
    
    reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 52, 300, 50)];
    reviewLabel.text = [[DateHelper getDateString:shareDate] stringByAppendingString: @" 今日回顾"];
    reviewLabel.font = [UIFont fontWithName:@"Ubuntu" size:25.f];
    reviewLabel.textColor = SHARING_TEXT_COLOR;
    reviewLabel.layer.shadowColor = [SHARING_TEXT_COLOR CGColor];
    reviewLabel.layer.shadowRadius = 2;
    reviewLabel.layer.shadowOpacity =1;
    reviewLabel.layer.shadowOffset = CGSizeMake(0, 0);
    [contentView addSubview:reviewLabel];
    
    
    pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [pieChart setDataSource:self];
    [pieChart setDelegate:self];
    [pieChart setStartPieAngle:M_PI_2];
    [pieChart setLabelFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16]];
    [pieChart setLabelRadius:100];
    [pieChart setShowPercentage:YES];
    [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [pieChart setPieCenter:CGPointMake(160, 280)];
    [pieChart setUserInteractionEnabled:YES];
    [pieChart setLabelShadowColor:[UIColor blackColor]];
    
    UIImage* bg = [UIImage imageNamed:@"TimePie_RingBG3"];
    UIImageView* bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 125, 320, 311)];
    [bgview setImage:bg];
    [pieChart addSubview:bgview];
    [pieChart sendSubviewToBack:bgview];
    
    [contentView addSubview:pieChart];
    
    [pieChart reloadData];
    
    //setup timer
    if(timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
    }
    
    
    int buttom = [self getAllItems:contentView];
    
    iuseLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, buttom, 300, 50)];
    iuseLabel.text = @"使用TimePie，了解自己的时间";
    iuseLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.f];
    iuseLabel.textColor = SHARING_TEXT_COLOR;
    iuseLabel.layer.shadowColor = [SHARING_TEXT_COLOR CGColor];
    iuseLabel.layer.shadowRadius = 3;
    iuseLabel.layer.shadowOpacity =.5;
    iuseLabel.layer.shadowOffset = CGSizeMake(0, 0);
    [contentView addSubview:iuseLabel];
    
//    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, (buttom+100));
    scroll.scrollEnabled = NO;
    
    [self initButtons:self.view];
    
    NSTimer * ncTimer = [NSTimer scheduledTimerWithTimeInterval:.6
                                                         target:self
                                                       selector:@selector(switchViewWithImage:)
                                                       userInfo:nil
                                                        repeats:NO];
    
    
}


- (void)reloadInfo{

    [_pieChartImage removeFromSuperview];
    
    [contentView removeFromSuperview];
    contentView = nil;
    contentView = [[UIView alloc] init];
    [scroll addSubview:contentView];
    [contentView addSubview:timePieLabel];
    [contentView addSubview:reviewLabel];
    [contentView addSubview:pieChart];
    [contentView addSubview:iuseLabel];
    //        [self.view addSubview:_pieChartImage];
    reviewLabel.text = [[DateHelper getDateString:shareDate] stringByAppendingString: @" 今日回顾"];
    [pieChart reloadData];
    
    
    int buttom = [self getAllItems:contentView];
    

    iuseLabel.frame = CGRectMake(65, buttom, 300, 50);
    [contentView addSubview:iuseLabel];
    
    //    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, (buttom+100));
    scroll.scrollEnabled = NO;
    NSTimer * ncTimer = [NSTimer scheduledTimerWithTimeInterval:.6
                                                         target:self
                                                       selector:@selector(switchViewWithImage:)
                                                       userInfo:nil
                                                        repeats:NO];

    
    
}


- (void)switchViewWithImage:(NSTimer *)chkTimer {
    _pieChartImage.frame = CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height);
    [self pieChartImage].image = [self imageWithView:contentView withWid:scroll.contentSize.width witHei:scroll.contentSize.height];
    [contentView removeFromSuperview];
    [scroll addSubview:[self pieChartImage]];
    [scroll setScrollEnabled:YES];
}


- (void)initWithDate:(NSDate*)date
{
    shareDate = date;
    if([date compare:[NSDate date]] == NSOrderedDescending){
        date = [NSDate date];
    }
    NSMutableArray * itemEntityList = [NSMutableArray arrayWithArray:[[TimingItemStore timingItemStore] getTimingItemsByDate:shareDate]];
    itemList = [[NSMutableArray alloc] init];
    for(TimingItemEntity * itemEntity in itemEntityList){
        [itemList addObject: [[TimingItemStore timingItemStore] TimingItemFromTimingItemEntity:itemEntity]];
    }

    
    if (_pieChartImage)
    {
        timingItemStore = [TimingItemStore timingItemStore];
        _pieChartImage.frame = CGRectMake(35, 35, 250, 250);
        
        
        
        
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        
        // Setting the swipe direction.
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        // Adding the swipe gesture on view
        [self.view setUserInteractionEnabled:YES];
        [self.view addGestureRecognizer:swipeLeft];
        [self.view addGestureRecognizer:swipeRight];
        

        

        //        itemList = [NSMutableArray arrayWithArray:[[TimingItemStore timingItemStore] allItems]];
        NSTimer * ncTimer = [NSTimer scheduledTimerWithTimeInterval:.6
                                                             target:self
                                                           selector:@selector(pieChartAppear:)
                                                           userInfo:nil
                                                            repeats:NO];
        
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    _WeiboviewController = [[WeiboViewController alloc] init];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithDate:[DateHelper getYesterday:[NSDate date]]];

}


- (UIImage *) imageWithView2:(UIView *)view
                     withWid:(int)width
                      witHei:(int)height
{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    
    
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);

    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        shareDate = [DateHelper getTomorrow:shareDate];
        if([shareDate compare:[NSDate date]] == NSOrderedDescending){
            shareDate = [NSDate date];
        }
        NSMutableArray * itemEntityList = [NSMutableArray arrayWithArray:[[TimingItemStore timingItemStore] getTimingItemsByDate:shareDate]];
        itemList = [[NSMutableArray alloc] init];
        for(TimingItemEntity * itemEntity in itemEntityList){
            [itemList addObject: [[TimingItemStore timingItemStore] TimingItemFromTimingItemEntity:itemEntity]];
        }
        
        [self reloadInfo];
//        [self.view removeFromSuperview];
//        [scroll removeFromSuperview];
//        scroll = nil;
//        [self initWithDate:[DateHelper getTomorrow:shareDate]];
//        [scroll removeFromSuperview];
//        scroll = nil;
//        [self pieChartAppear:nil];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        shareDate = [DateHelper getYesterday:shareDate];
        if([shareDate compare:[[TimingItemStore timingItemStore] getStartDate]] == NSOrderedAscending){
            shareDate = [DateHelper getTomorrow:shareDate];
        }
        
        
        NSMutableArray * itemEntityList = [NSMutableArray arrayWithArray:[[TimingItemStore timingItemStore] getTimingItemsByDate:shareDate]];
        itemList = [[NSMutableArray alloc] init];
        for(TimingItemEntity * itemEntity in itemEntityList){
            [itemList addObject: [[TimingItemStore timingItemStore] TimingItemFromTimingItemEntity:itemEntity]];
        }
        
        [self reloadInfo];
//        [self.view removeFromSuperview];
//        [scroll removeFromSuperview];
//        scroll = nil;
//        [self initWithDate:[DateHelper getYesterday:shareDate]];
//        shareDate = [DateHelper getYesterday:shareDate];
//        [scroll removeFromSuperview];
//        scroll = nil;
//        [self pieChartAppear:nil];
        
    }
    
}



- (UIImage *) imageWithView:(UIView *)view
                    withWid:(int)width
                     witHei:(int)height
{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque,0.0);// [[UIScreen mainScreen] scale]);
    //fill with white back ground
    
    
    
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
    
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}






- (void)initButtons:(UIView*)intoView
{
    UIButton *weiboButton = [[UIButton alloc] initWithFrame:CGRectMake(13, SCREEN_HEIGHT - 54, 93, 41)];
    [weiboButton setImage:[UIImage imageNamed:@"weiboButton"] forState:UIControlStateNormal];
    [weiboButton addTarget:self action:@selector(weiboButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [intoView addSubview:weiboButton];
    
    UIButton *wechatButton = [[UIButton alloc] initWithFrame:CGRectMake(114, SCREEN_HEIGHT - 54, 93, 41)];
    [wechatButton setImage:[UIImage imageNamed:@"wechatButton"] forState:UIControlStateNormal];
    [wechatButton addTarget:self action:@selector(wechatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [intoView addSubview:wechatButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(215, SCREEN_HEIGHT - 54, 93, 41)];
    [cancelButton setImage:[UIImage imageNamed:@"cancelShareButton"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [intoView addSubview:cancelButton];
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

- (int)getAllItems:(UIView*)intoView
{
    for (int i = 0; i < itemList.count; i++)
    {
        /*
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 300 + 20 * i, 100, 20)];
        itemLabel.text = [[itemList objectAtIndex:i] itemName];
        itemLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:15.f];
        itemLabel.textColor = [[ColorThemes colorThemes] getColorAt:[[itemList objectAtIndex:i] itemColor]];
        [self.view addSubview:itemLabel];
        */
        SharingTimingItemView * stiv = [[SharingTimingItemView alloc] initWithFrame:CGRectMake(70, 500+i*50, 100, 100) withItem:[itemList objectAtIndex:i]];
        
        [intoView addSubview:stiv];
    
    }
    
    return 500+itemList.count*50;
    
}

#pragma mark - target selectors

- (void)weiboButtonPressed:(id)sender
{
    [self pieChartImage].image = [self imageWithView:contentView withWid:scroll.contentSize.width witHei:scroll.contentSize.height];
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
    [self pieChartImage].image = [self imageWithView:contentView withWid:scroll.contentSize.width witHei:scroll.contentSize.height];
    [self sendContent:@"Time Pie Shared" image:_pieChartImage.image];
}


- (void)sendContent:(NSString *)text image:(UIImage *)img
{
    if(text!=nil){
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = @"Test Text";
//        req.bText = YES;
        req.scene = weixin_scene_pengyouquan;
        [WXApi sendReq:req];
    }
    if(img!=nil){
        
        WXMediaMessage *message = [WXMediaMessage message];
        //[message setThumbImage:img];
        
        WXImageObject *ext = [WXImageObject object];
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5thumb" ofType:@"png"];
        NSLog(@"here");
        
        
        
//        ext.imageData = UIImageJPGRepresentation(img);
//        ext.imageData = UIImageJPEGRepresentation(img, 1);
//        UIImage* image = [UIImage imageWithContentsOfFile:filePath];
        //UIImage* image = [UIImage imageWithData:ext.imageData];
        ext.imageData = UIImagePNGRepresentation(img);
        
        //    UIImage* image = [UIImage imageNamed:@"res5thumb.png"];
        //    ext.imageData = UIImagePNGRepresentation(image);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req1 = [[SendMessageToWXReq alloc] init];
//        req1.bText = NO;
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







// for pie chart
//////////////////
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [itemList count];// [[timingItemStore allItems] count];
}



- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    
    TimingItem * item = [itemList objectAtIndex:index]; // [[timingItemStore allItems] objectAtIndex:index];
    if(item){
        return [NSString stringWithFormat:@"%@\n%@",[item itemName], [item getTimeString]];
    }
    
    return nil;
}


- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index;
{
    
    TimingItem * item = [itemList objectAtIndex:index]; // [[timingItemStore allItems] objectAtIndex:index];
    if(item){
        return [item time];
    }
    return 0;
}


- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    TimingItem * item = [itemList objectAtIndex:index]; // [[timingItemStore allItems] objectAtIndex:index];
    
    if(item){
        return [[ColorThemes colorThemes] getColorAt:item.itemColor];
    }
    
    return [UIColor blackColor];
}




- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    
}



-(void)pollTime
{
//    [pieChart reloadData];
}






@end
