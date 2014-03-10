//==============================================================================
//
//  InfColorPickerController.h
//  InfColorPicker
//
//  Created by Troy Gaul on 7 Aug 2010.
//
//  Copyright (c) 2011-2013 InfinitApps LLC: http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>
#import "TimingItem.h"
@protocol InfColorPickerControllerDelegate;

//------------------------------------------------------------------------------

@interface InfColorPickerController : UIViewController

// Public API:

+ (InfColorPickerController*) colorPickerViewController;
+ (CGSize) idealSizeForViewInPopover;

- (void) presentModallyOverViewController: (UIViewController*) controller;
- (void) presentModallyOverViewController: (UIViewController*) controller withItem:(TimingItem*) item;
@property (nonatomic) UIColor* sourceColor;
@property (nonatomic) UIColor* resultColor;
@property (nonatomic,strong) IBOutlet UITextField * textName;
@property (weak, nonatomic) id <InfColorPickerControllerDelegate> delegate;
@property (nonatomic) TimingItem * timingItem;

- (IBAction)backgroundTapped:(id)sender;

@end

//------------------------------------------------------------------------------

@protocol InfColorPickerControllerDelegate

@optional

//- (void) colorPickerControllerDidFinish: (InfColorPickerController*) controller;
	// This is only called when the color picker is presented modally.
- (void) colorPickerControllerDidFinish:(InfColorPickerController *)controller
                               nameText:(NSString *)name;
- (void) colorPickerControllerDidChangeColor: (InfColorPickerController*) controller;


@end

//------------------------------------------------------------------------------
