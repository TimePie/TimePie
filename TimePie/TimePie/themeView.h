//
//  themeView.h
//  TimePie
//
//  Created by 大畅 on 14-5-7.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface themeView : UIView
{
    NSString *themeName;
}
@property (strong, nonatomic) UILabel *themeNameLabel;
@property (strong, nonatomic) NSMutableArray *themeColorArray;

- (void)initThemeNameWithString:(NSString*)name ColorBoard:(NSMutableArray*)colors;

@end
