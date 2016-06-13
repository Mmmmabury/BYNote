//
//  ProfileSilderMenu.m
//  BYNote
//
//  Created by cby on 16/6/6.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ProfileSliderMenu.h"
#import <MessageUI/MessageUI.h>
#import <ENSDK.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ProfileSliderMenu ()
@property (nonatomic, assign) BOOL isTriggle;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@end

@implementation ProfileSliderMenu

- (instancetype)init{
    
    self = [super initWithFrame:CGRectMake(-SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT)];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.2078 green:0.5137 blue:0.8 alpha:1.0];
        [self createSubView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blueViewTapAction:) name:@"sliderDismiss" object:nil];
    }
    return self;
}

# pragma mark 创建子视图
- (void) createSubView{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    //        _blurView.hidden = YES;
    //        [self addSubview:_blurView];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _blurView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _blurView.hidden = YES;
    _blurView.alpha = 0.0f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blueViewTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_blurView addGestureRecognizer:tap];
    [keyWindow addSubview:_blurView];
    
    _isTriggle = NO;
    [keyWindow addSubview:self];
    
    [self createButtons];
}
// 创建按钮
- (void) createButtons{
    
    //        NSArray *s = @[@"印象笔记", @"iCloud", @"从剪贴板复制", @"指纹设置", @"密码设置", @"评分", @"反馈"];
    ENSession *session = [ENSession sharedSession];
    NSString *logKey = session.isAuthenticated ? @"logout" : @"login";
    int logStatus = session.isAuthenticated ? SliderButtonActive : SliderButtonNotActive;
    NSArray *s = @[NSLocalizedString(logKey, nil),
                   NSLocalizedString(@"icloud", nil),
                   NSLocalizedString(@"clipboard", nil),
                   NSLocalizedString(@"finger", nil),
                   NSLocalizedString(@"password", nil),
                   NSLocalizedString(@"rating", nil),
                   NSLocalizedString(@"feedback", nil),];
    int a[7] = {
        logStatus,
        SliderButtonNotActive,
        SliderButtonNotActive,
        SliderButtonActive,
        SliderButtonNotActive,
        SliderButtonNormal,
        SliderButtonNormal};
    for (int i = 0; i < s.count; i++) {
        
        CGRect frame = CGRectMake(20, 50 + i * 50, SCREEN_WIDTH / 2 - 40, 40);
        ProfileSliderMenuButton *button = [[ProfileSliderMenuButton alloc] initWithFrame:frame andTitle:s[i]];
        button.tag = 100 + i;
        button.status = a[i];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

#pragma mark 动画
// 侧边栏动画
- (void) triggle{
    
    if (_isTriggle) {
        
        [UIView animateWithDuration:0.3f animations:^{
            
            self.transform = CGAffineTransformIdentity;
            _blurView.alpha = 0.0f;
        } completion:^(BOOL finished){
            
            _blurView.hidden = YES;
        }];
    }else{
        
        [UIView animateWithDuration:0.3f animations:^{
            
            self.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH / 2, 0);
            _blurView.alpha = 1.0f;
        }];
        _blurView.hidden = NO;
    }
    _isTriggle = !_isTriggle;
}

#pragma mark 响应事件

- (void)blueViewTapAction:(id)sender {
	
    [self triggle];
}

- (void)buttonAction:(ProfileSliderMenuButton *)sender {
	
    NSURL *appStoreUrl =[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=291586600&amp;amp;mt=8"];
    switch (sender.tag) {
        case 100:
            
            [_delegate linkToEverNote:sender];
            break;
            
        case 101:
            
            break;
        case 105:
           
            [[UIApplication sharedApplication] openURL:appStoreUrl];
            break;
        case 106:
            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://admin@hzlzh.com"]];
            [_delegate sendEmailAction];
            break;
        default:
            break;
    }
}


@end
