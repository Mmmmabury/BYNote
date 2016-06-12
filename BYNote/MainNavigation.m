//
//  MainNavigation.m
//  BYNote
//
//  Created by cby on 16/6/4.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "MainNavigation.h"

@implementation MainNavigation

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.2078 green:0.5882 blue:0.8588 alpha:1.0];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationBarHidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

@end
