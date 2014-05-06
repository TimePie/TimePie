//
//  ColorThemes.m
//  TimePie
//
//  Created by Max Lu on 5/2/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "ColorThemes.h"
#import "BasicUIColor+UIPosition.h"
@implementation ColorThemes


- (id)init
{
    self =[super init];
    if(self){
        [self defaultColorTheme];
    }
    return self;
}



+ (ColorThemes *)colorThemes
{
    static ColorThemes * colorThemes = nil;
    if(!colorThemes){
        colorThemes =[[super allocWithZone:nil] init];
    }
    return colorThemes;
}


- (NSArray *)defaultColorTheme{
    if(!defaultColorTheme){
        defaultColorTheme = [[NSMutableArray alloc] init];
        [defaultColorTheme addObject:REDNO1];
        [defaultColorTheme addObject:BLUENO2];
        [defaultColorTheme addObject:GREENNO3];
        [defaultColorTheme addObject:PINKNO04];
    }
    return defaultColorTheme;
}

- (NSArray *)defaultLightColorTheme{
    if(!defaultLightColorTheme){
        defaultLightColorTheme = [[NSMutableArray alloc] init];
        [defaultLightColorTheme addObject:RedNO1_light];
        [defaultLightColorTheme addObject:BLUENO2_light];
        [defaultLightColorTheme addObject:GREENNO3_light];
        [defaultLightColorTheme addObject:PINKNO04_light];
    }
    return defaultLightColorTheme;
}


- (UIColor *)getColorAt:(int)index
{
    int size = [[self defaultColorTheme] count];
    return [[self defaultColorTheme] objectAtIndex:index%size];
}

- (UIColor *)getLightColorAt:(int)index
{
    int size = [[self defaultLightColorTheme] count];
    return [[self defaultLightColorTheme] objectAtIndex:index%size];
}



@end
