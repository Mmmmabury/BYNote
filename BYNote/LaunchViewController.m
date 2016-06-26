//
//  LaunchViewController.m
//  BYNote
//
//  Created by cby on 16/6/22.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "LaunchViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self authenticationWithBiometrics];
    [self passwordLock];
}

- (BOOL) authenticationWithBiometrics{
    
    //    authenticationWithBiometrics
    NSString *authBio = [[NSUserDefaults standardUserDefaults] objectForKey:@"authenticationWithBiometrics"];
    if (!authBio) {
        
        
    }
    if ([authBio boolValue]) {
        
        //        [self authB];
    }
    return YES;
}

- (BOOL) passwordLock{
    
    // passwordLock
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (password || password.length != 0) {
        
        // 没有密码锁
    } else{
        
        // 有密码锁
    }
    return YES;
}
@end
