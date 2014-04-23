//
//  CreateItemViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateItemViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView *colorTag;
    UITextField *inputField;
    UILabel *initInputLabel;
}
@property (strong, nonatomic) UITableView *CIVC_mainVessel;

@end
