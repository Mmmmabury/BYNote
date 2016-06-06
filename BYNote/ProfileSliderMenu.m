//
//  ProfileSilderMenu.m
//  BYNote
//
//  Created by cby on 16/6/6.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ProfileSliderMenu.h"

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
        
        self.backgroundColor = [UIColor blueColor];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

//        _blurView.hidden = YES;
//        [self addSubview:_blurView];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
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
    }
    return self;
}

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

- (void)blueViewTapAction:(UITapGestureRecognizer *)sender {
	
    [self triggle];
}
@end
