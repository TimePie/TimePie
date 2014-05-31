//
//  ColorThemes.m
//  TimePie
//
//  Created by Max Lu on 5/2/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import "ColorThemes.h"
#import "BasicUIColor+UIPosition.h"

#import "TimingItem1.h"

@implementation ColorThemes


- (id)init
{
    self =[super init];
    if(self){
        [self defaultColorTheme];
        colorPointer = 0;
        taken = [[NSMutableArray alloc] init];
        
    }
    return self;
}



- (void)initTaken:(NSArray*)array
{
    taken = [[NSMutableArray alloc] init];
    for(TimingItem * item in array){
        [taken addObject:[NSNumber numberWithInt:item.itemColor]];
    }
}



- (NSArray *)getAvailableColors
{
    int size=[[self defaultColorTheme] count];
    int currentP = colorPointer;
    int iterP = currentP;
    NSMutableArray * availColors = [[NSMutableArray alloc] init];
    if(![taken containsObject:[NSNumber numberWithInt:iterP]]){
        [availColors addObject:[NSNumber numberWithInt:iterP]];
    }
    iterP++;
    iterP%=size;
    while(iterP!=currentP){
        if(![taken containsObject:[NSNumber numberWithInt:iterP]]){
            [availColors addObject:[NSNumber numberWithInt:iterP]];
        }
        iterP++;
        iterP%=size;
    }
    
    return availColors;
}


- (int)getAColor
{
    int size=[[self defaultColorTheme] count];
    
    if(colorPointer>=size){
        colorPointer%=size;
    }
    int flag = 0;
    while([taken containsObject:[NSNumber numberWithInt:colorPointer]]){
        colorPointer++;
        if(colorPointer>=size){
            colorPointer%=size;
            if(flag==2) {
                [taken addObject:[NSNumber numberWithInt:colorPointer]];
                return colorPointer;

            }
            flag++;
        }
    }
    [taken addObject:[NSNumber numberWithInt:colorPointer]];
    return colorPointer;
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
        [defaultColorTheme addObject:BROWNN05];
        [defaultColorTheme addObject:YELLOWN06];
        [defaultColorTheme addObject:PURPLEN07];
        [defaultColorTheme addObject:P01N08];
        [defaultColorTheme addObject:P01N09];
        [defaultColorTheme addObject:P01N10];
        
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
        [defaultLightColorTheme addObject:BROWNN05_light];
        [defaultLightColorTheme addObject:YELLOWN06_light];
        [defaultLightColorTheme addObject:PURPLEN07_light];
        [defaultLightColorTheme addObject:P01N08_light];
        [defaultLightColorTheme addObject:P01N09_light];
        [defaultLightColorTheme addObject:P01N10_light];
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
