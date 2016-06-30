//
//  LaunchViewController.m
//  BYNote
//
//  Created by cby on 16/6/22.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "LaunchViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "MainNavigation.h"

@interface LaunchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *b;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"大飞第三方" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:18.0f]}];
    [_b setAttributedTitle:str forState:UIControlStateNormal];
    [self authenticationWithBiometrics];
    [self passwordLock];
    [self pasteboard];
}

- (IBAction)buttonAc:(UIButton *)sender {
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainNavigation *mainNav = [sb instantiateViewControllerWithIdentifier:@"MainNav"];
    
    CATransition *transition = [[CATransition alloc] init];
    transition.type = kCATransitionFade;
//    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0;
//    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:@"transition"];
    window.rootViewController = mainNav;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainNavigation *mainNav = [sb instantiateViewControllerWithIdentifier:@"MainNav"];
//    window.rootViewController = mainNav;
}

- (void) pasteboard{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSLog(@"%@", pasteboard.string);
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
