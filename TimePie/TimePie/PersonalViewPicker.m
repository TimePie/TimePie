//
//  PersonalViewPicker.m
//  TimePie
//
//  Created by 大畅 on 14-4-21.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "PersonalViewPicker.h"
#import "BasicUIColor+UIPosition.h"
#define MyDateTimePickerToolbarHeight 50

@interface PersonalViewPicker()

@property (nonatomic, assign, readwrite) UIPickerView *picker;

@property (nonatomic, assign) id doneTarget;
@property (nonatomic, assign) id cancelTarget;
@property (nonatomic, assign) SEL doneSelector;
@property (nonatomic, assign) SEL cancelSelector;

- (void) donePressed;
@end

@implementation PersonalViewPicker

- (id) initWithFrame: (CGRect) frame
{
    if ((self = [super initWithFrame: frame]))
    {
        self.backgroundColor = [UIColor whiteColor];
        _pickerData = [[NSArray alloc] initWithObjects:@"过去一周",@"过去一个月",@"过去三个月",@"过去六个月",@"过去一年", nil];
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, MyDateTimePickerToolbarHeight, frame.size.width, frame.size.height - MyDateTimePickerToolbarHeight)];
        picker.dataSource = self;
        picker.delegate = self;
        [self addSubview: picker];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, MyDateTimePickerToolbarHeight)];
        toolbar.barTintColor = MAIN_UI_COLOR;
        toolbar.tintColor = [UIColor whiteColor];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"完成" style: UIBarButtonItemStyleBordered target: self action: @selector(donePressed)];
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithTitle: @"                查看范围              " style: UIBarButtonItemStyleBordered target: self action: nil];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"取消" style: UIBarButtonItemStyleBordered target: self action: @selector(cancelPressed)];
        toolbar.items = [NSArray arrayWithObjects:cancelButton,flexibleSpace, doneButton, nil];
        
        [self addSubview: toolbar];
        
        self.picker = picker;
        picker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

#pragma mark - UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

#pragma mark - UIPickerView Delegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    pickerView.tintColor = [UIColor blueColor];
    return [_pickerData objectAtIndex:row];
}

- (void) donePressed
{
    if (self.doneTarget)
    {
        [self.doneTarget performSelector:self.doneSelector withObject:nil afterDelay:0];
    }
}

- (void) cancelPressed
{
    if (self.cancelTarget)
    {
        [self.cancelTarget performSelector:self.cancelSelector withObject:nil afterDelay:0];
    }
}

- (void) addTargetForDoneButton: (id) target action: (SEL) action
{
    self.doneTarget = target;
    self.doneSelector = action;
}

- (void) addTargetForCancelButton: (id) target action: (SEL) action
{
    self.cancelTarget=target;
    self.cancelSelector=action;
}

@end
