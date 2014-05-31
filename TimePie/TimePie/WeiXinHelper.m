//
//  WeiXinHelper.m
//  TimePie
//
//  Created by Max Lu on 5/31/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "WeiXinHelper.h"

@implementation WeiXinHelper



+ (void) sendContent:(NSString *)text image:(UIImage *)img
{
    enum WXScene _scene;
    _scene = WXSceneSession;
    if(text!=nil){

        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = @"Test Text";
        req.bText = YES;
        req.scene = _scene;
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
        req1.scene = _scene;
        
        [WXApi sendReq:req1];
    }
    
}


@end
