//
//  AppDelegate.m
//  BYNote
//
//  Created by cby on 16/5/24.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <ENSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *SANDBOX_HOST = ENSessionHostSandbox;
    
    // To get an API key, visit http://dev.evernote.com/documentation/cloud/
    NSString *CONSUMER_KEY = @"epapa";
    NSString *CONSUMER_SECRET = @"e8b10439a76fa73d";
    
    [ENSession setSharedSessionConsumerKey:CONSUMER_KEY
                            consumerSecret:CONSUMER_SECRET
                              optionalHost:SANDBOX_HOST];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Launch" bundle:[NSBundle mainBundle]];
    LaunchViewController *launchVC = [storyboard instantiateViewControllerWithIdentifier:@"launch"];
    _window = [[UIWindow alloc] init];
    _window.rootViewController = launchVC;
    [self.window makeKeyAndVisible];
    return YES;
}

// 指纹锁
- (void) authB{
    
    LAContext *context = [LAContext new];
    // 开始使用指纹识别
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            
        }
        if (error) {
            
            
        }
        
    }];
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
