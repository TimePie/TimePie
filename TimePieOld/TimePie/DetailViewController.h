//
//  DetailViewController.h
//  TimePie
//
//  Created by Storm Max on 14-1-10.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimingItem;

@interface DetailViewController : UIViewController<UINavigationBarDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *itemName;
}

@property (nonatomic, strong) TimingItem* item;
@property (nonatomic, copy) void (^dismissBlock)(void);


- (IBAction)backgroundTapped:(id)sender;

@end
