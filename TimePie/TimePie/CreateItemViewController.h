//
//  CreateItemViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerView.h"

@class TimingItem;
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

/**
 *  是否为编辑事项
 */
@property BOOL isEditView;

@property (strong, nonatomic) TimingItem *editItem;
@property (strong, nonatomic) NSString *editItemName;
@property (strong, nonatomic) UIColor *editItemColor;
@property (strong, nonatomic) NSString *editItemTag;
@property BOOL isEditItemRoutine;

@end
