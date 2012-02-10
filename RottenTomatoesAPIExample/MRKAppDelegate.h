//
//  MRKAppDelegate.h
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/2/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRKConstants.h"
#import "NetworkEngine.h"
#import "FBConnect.h"

#define ApplicationDelegate ((MRKAppDelegate *)[UIApplication sharedApplication].delegate)

@class MRKViewController;

@interface MRKAppDelegate : UIResponder <UIApplicationDelegate, UITabBarDelegate, FBSessionDelegate>
{
    UITabBarController *tabBarController;
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
    NSArray *permissions;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, retain) NSArray *permissions;

@property (strong, nonatomic) MRKViewController *viewController;

@property (strong, nonatomic) NetworkEngine *networkEngine;


@end
