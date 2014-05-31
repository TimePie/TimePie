//
//  ColorThemes.h
//  TimePie
//
//  Created by Max Lu on 5/2/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorThemes : NSObject
{
    NSMutableArray * defaultColorTheme;
    NSMutableArray * defaultLightColorTheme;
    int colorPointer;
    NSMutableArray * taken;
}


+ (ColorThemes *)colorThemes;
- (NSArray *)defaultColorTheme;
- (NSArray *)defaultLightColorTheme;
- (UIColor *)getColorAt:(int)index;
- (UIColor *)getLightColorAt:(int)index;
- (void)initTaken:(NSArray*)array;
- (int)getAColor;
- (NSArray *)getAvailableColors;

@end
