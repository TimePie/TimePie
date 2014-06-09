//
//  CreateItemViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerView.h"

@interface CreateItemViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate,ColorPickerViewDelegate>
{
    UIButton *colorTagButton;
    UITextField *inputField;
    UILabel *initInputLabel;
    UILabel *tagLabel;
    UITextField *tagInputField;
    UILabel *addTagLabel;
    NSMutableArray *tagTextArray;
    UIButton *routineButton;
    UIImageView *tagCheck;
    NSMutableArray *tagCellSelectedFlag;
}
@property (strong, nonatomic) UITableView *CIVC_mainVessel;

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *currentTagOfItem;

@end
