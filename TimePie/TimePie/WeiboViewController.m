//
//  WeiboViewController.m
//  weobo_test
//
//  Created by topcoderJK on 5/25/14.
//  Copyright (c) 2014 topcoderJK. All rights reserved.
//

#import "WeiboViewController.h"

@interface WeiboViewController ()

@end

@implementation WeiboViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _WebView.delegate = self;
    self.title=@"微博分享";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"StatsBackButton"] style:nil target:self action:@selector(exitButtonPressed)];
    self.navigationItem.leftBarButtonItem=backButton;
    [self.navigationBar pushNavigationItem:self.navigationItem animated:NO];
    self.navigationBar.clipsToBounds = YES;
    
    
    
    NSLog(@"here aaaa");
    // Do any additional setup after loading the view.
}

- (void)authorize:(NSURLRequest*) request image:(UIImage*)img text:(NSString*)txt
{
    _image = img;
    _content = txt;
    [_WebView  loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{


        NSLog(@"1\n");

        NSString* code=[_WebView.request.URL.absoluteString substringFromIndex:47];
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/oauth2/access_token" httpMethod:@"POST" params:[NSMutableDictionary dictionaryWithObjectsAndKeys: @"1524504959", @"client_id",@"97110fa299736970f18ca817c121e453" ,@"client_secret",@"authorization_code",@"grant_type",code,@"code",@"https://api.weibo.com/oauth2/default.html",@"redirect_uri",nil] delegate:self  withTag:@"text1"];
    
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
        NSLog(result);

        NSRange range2=[result rangeOfString:@"access_token"];

        NSRange range=[result rangeOfString:@"error_code"];

    
        if(range2.length >0 && range.length<=0){
            NSLog(@"2\n");
            NSLog(result);
        NSArray* Strings=[result componentsSeparatedByString:@"\""];
        self.token=Strings[3];
        [WBHttpRequest requestWithAccessToken:self.token url:@"https://api.weibo.com/2/statuses/upload.json" httpMethod:@"POST" params:[NSMutableDictionary dictionaryWithObjectsAndKeys: _content, @"status",_image, @"pic", nil] delegate:self  withTag:@"text1"];
        [self exitButtonPressed];
        }
    
}
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"error");
}

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"here");
    
}

- (void)exitButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
