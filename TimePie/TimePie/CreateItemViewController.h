//
//  CreateItemViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateItemViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
{
    UIView *colorTag;
    UITextField *inputField;
    UILabel *initInputLabel;
    UITextField *tagInputField;
    UILabel *addTagLabel;
    NSMutableArray *tagTextArray;
    UIButton *routineButton;
}
@property (strong, nonatomic) UITableView *CIVC_mainVessel;

@property (strong, nonatomic) NSString *itemName;

@end
