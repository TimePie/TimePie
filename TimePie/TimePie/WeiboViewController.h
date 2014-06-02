//
//  WeiboViewController.h
//  weobo_test
//
//  Created by topcoderJK on 5/25/14.
//  Copyright (c) 2014 topcoderJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

@interface WeiboViewController : UIViewController<WBHttpRequestDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *WebView;
@property (retain,nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain, nonatomic) NSString* token;
@property (retain, nonatomic) NSString* content;

@property (retain, nonatomic) UIImage* image;

- (void)authorize:(NSURLRequest*) request image:(UIImage*)img text:(NSString*)txt;


@end
