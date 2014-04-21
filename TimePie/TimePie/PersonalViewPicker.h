//
//  PersonalViewPicker.h
//  TimePie
//
//  Created by 大畅 on 14-4-21.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalViewPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *pickerData;
}

@property (nonatomic, assign, readonly) UIPickerView *picker;

- (void) addTargetForDoneButton: (id) target action: (SEL) action;
- (void) addTargetForCancelButton: (id) target action: (SEL) action;

@end
