//
//  AppDelegate.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 16/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "VCAppDelegate.h"
#import "VCTabBarViewController.h"
#import "RZUtils/RZUtils.h"

@interface VCAppDelegate ()
@property (nonatomic,retain) VCTabBarViewController * tabBarController;
@end

@implementation VCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    RZSimNeedle();
    
    [self setupWorkerThread];
    
    self.worldShape = [RZShapeFile shapeFileWithBase:[RZFileOrganizer bundleFilePath:@"TM_WORLD_BORDERS-0.2"]];
    
    self.db = [FMDatabase databaseWithPath:[RZFileOrganizer writeableFilePath:@"records.db"]];
    [self.db open];
    [VCShapeSetOrganizer ensureDbStructure:self.db];

    self.organizer = [VCShapeSetOrganizer organizerWithDatabase:self.db andThread:self.worker];
    [self.organizer loadSelectionName:@"Default" withDefinitionName:@"Countries"];
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        //self.splitViewController = [[TSSplitViewController alloc] initWithNibName:nil bundle:nil];
        //[self.window setRootViewController:self.splitViewController];
    }else{
        self.tabBarController = [[VCTabBarViewController alloc] initWithNibName:nil bundle:nil];
        [self.window setRootViewController:self.tabBarController];
    }
    
    // Override point for customization after application launch.
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

#pragma mark thread mgmt

-(void)setupWorkerThread{
    dispatch_queue_t queue = dispatch_queue_create("net.ro-z.worker", DISPATCH_QUEUE_SERIAL);
    self.worker = queue;

}

-(void)tabBarToStats{
    [self.tabBarController setSelectedIndex:3];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)registerDefaults{
    //[[NSUserDefaults standardUserDefaults] registerDefaults:@{}];
}

@end
