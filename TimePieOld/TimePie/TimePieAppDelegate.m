//
//  TimePieAppDelegate.m
//  TimePie
//
//  Created by Storm Max on 14-1-9.
//  Copyright (c) 2014年 Storm Max. All rights reserved.
//

#import "TimePieAppDelegate.h"
#import "TPMainViewController.h"
#import "TimeItemBucket.h"
#import "TryPicChartViewController.h"

@implementation TimePieAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    TPMainViewController * tpvc = [[TPMainViewController alloc] init];
    TryPicChartViewController *pieVC= [[TryPicChartViewController alloc] init];
    
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:tpvc];
    
    [[self window] setRootViewController:nvc];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success= [[TimeItemBucket timeItemBucket] saveChanges];
    if (success) {
        NSLog(@"Save all of TimingItems");
    }else{
        NSLog(@"Fail to save TimingItems");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
