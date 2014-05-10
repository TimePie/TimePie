//
//  themeDetailView.h
//  TimePie
//
//  Created by 大畅 on 14-5-10.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "themeView.h"

@interface themeDetailView : themeView
{
    NSArray *colorArray;
}

- (void)initThemeWithColorBoard:(NSArray*)colors;

@end
