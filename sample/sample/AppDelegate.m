//
//  AppDelegate.m
//  sample
//
//  Created by Jason on 15/6/23.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "CurrentWeatherViewController.h"
#import "DailyForecastViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CurrentWeatherViewController *currentWeatherViewController = [[CurrentWeatherViewController alloc] init];
    currentWeatherViewController.title = @"实时";
    UINavigationController *currentWeatherNavigationController = [[UINavigationController alloc] initWithRootViewController:currentWeatherViewController];
    
    DailyForecastViewController *dailyForecastViewController = [[DailyForecastViewController alloc] init];
    dailyForecastViewController.title = @"预报";
    UINavigationController *dailyForecastNavigationController = [[UINavigationController alloc] initWithRootViewController:dailyForecastViewController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[currentWeatherNavigationController, dailyForecastNavigationController];
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
