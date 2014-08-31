//
//  CARAppDelegate.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/9/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARAppDelegate.h"

#import "DEMOCoverViewController.h"
#import "DEMOCoverScrollController.h"

#import "DEMOTableViewController.h"
#import "DEMOCollectionViewController.h"
#import "DEMOControlViewController.h"
#import "DEMOTextViewController.h"

@implementation CARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:tabBarController.viewControllers];
	
	[viewControllers addObject:[self demoCoverScrollViewController]];
//	[viewControllers addObject:[self demoCoverViewController]];
	
	tabBarController.viewControllers = viewControllers;
	
	return YES;
}

- (DEMOTableViewController *)demoTableViewController {
	return [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"DEMOTableView"];
}

- (DEMOCollectionViewController *)demoCollectionViewController {
	return [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"DEMOCollectionView"];
}

- (DEMOControlViewController *)controlViewController {
	return [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"ControlView"];
}

- (DEMOTextViewController *)textViewController {
	return [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"DEMOTextView"];
}

- (UIViewController *)demoCoverViewController {
	
	DEMOTableViewController *demoTableViewController = [self demoTableViewController];
	DEMOCoverViewController *coverViewController = [[DEMOCoverViewController alloc] init];
	coverViewController.rootViewController = demoTableViewController;
	
	return coverViewController;
}

- (UIViewController *)demoCoverScrollViewController {
	
	DEMOControlViewController *controlViewController = [self controlViewController];
	DEMOTextViewController *textViewController = [self textViewController];
	DEMOTableViewController *demoTableViewController = [self demoTableViewController];
	DEMOCollectionViewController *demoCollectionViewController = [self demoCollectionViewController];
	DEMOTableViewController *demoTableViewController2 = [self demoTableViewController];

//	CARCoverScrollController *coverScrollViewController = [[CARCoverScrollController alloc] init];
	DEMOCoverScrollController *coverScrollViewController = [[DEMOCoverScrollController alloc] init];
	
	coverScrollViewController.viewControllers = @[
												  controlViewController,
												  textViewController,
												  demoTableViewController,
												  demoCollectionViewController,
												  demoTableViewController2,
												  ];
	
	return coverScrollViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
