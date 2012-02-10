//
//  MRKAppDelegate.m
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/2/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import "MRKAppDelegate.h"

#import "MRKViewController.h"
#import "MRKAboutViewController.h"
#import "NetworkEngine.h"


@implementation MRKAppDelegate

@synthesize facebook;
@synthesize permissions, userPermissions;
@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize networkEngine;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* FACEBOOK initialization, setup, check for access_token */
    // Initialize permissions
    permissions = [[NSArray alloc] initWithObjects:@"read_stream", @"publish_stream", @"offline_access", nil];
    //facebook = [[Facebook alloc] initWithAppId:kFacebookAppID andDelegate:self];
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
     */
    tabBarController = [[UITabBarController alloc] init];
    [tabBarController.delegate self];
    
    
    
    /* NETWORK SETUP */
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary]; 
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    
    self.networkEngine = [[NetworkEngine alloc] 
                          initWithHostName:kBaseURL 
                          customHeaderFields:nil];
    [self.networkEngine useCache];
    

    MRKAboutViewController *aboutViewController = [[MRKAboutViewController alloc] init];
    aboutViewController.title = @"AboutApp";
    aboutViewController.tabBarItem.image = [UIImage imageNamed:@"info"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[MRKViewController alloc] initWithNibName:@"MRKViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[MRKViewController alloc] initWithNibName:@"MRKViewController_iPad" bundle:nil];
    }
    UINavigationController* navController = [[UINavigationController alloc]
                                             initWithRootViewController:self.viewController];
    navController.title = @"Movies";
    navController.tabBarItem.image = [UIImage imageNamed:@"movietab"];
    
    NSArray* controllers = [NSArray arrayWithObjects:navController, aboutViewController, nil];
    tabBarController.viewControllers = controllers;
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma FACEBOOK

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    DLog(@"openURL: %@", [url absoluteString]);
    return [self.facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}
#pragma mark - FBSessionDelegate Methods
/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    DLog(@"did logout");
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    DLog(@"did not login");
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [self fbDidLogout];
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

@end
