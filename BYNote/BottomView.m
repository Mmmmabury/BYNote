//
//  BottomView.m
//  BYNote
//
//  Created by cby on 16/6/13.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "BottomView.h"
#import "ViewController.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface BottomView ()

@property (nonatomic, weak) ViewController *delegate;
@end
@implementation BottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype) initWithFrame:(CGRect)frame andVC: (ViewController *)vc{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _delegate = vc;
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

- (void) createSubViews{
    
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [profileButton setTitle:@"我" forState:UIControlStateNormal];
    [profileButton setTitleColor:[UIColor colorWithRed:0.2235 green:0.6 blue:0.8549 alpha:1.0] forState:UIControlStateNormal];
    profileButton.frame = CGRectMake(0, 0, 60, 60);
    profileButton.center = CGPointMake(profileButton.center.x, 32);
    [profileButton addTarget:_delegate action:@selector(profile:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:profileButton];
    
    // 弹出编辑页面按钮
    UIButton *presentEditView = [UIButton buttonWithType:UIButtonTypeCustom];
    presentEditView.frame = CGRectMake(0, 0, 50, 50);
    presentEditView.center = CGPointMake(SCREEN_WIDTH / 2, 32);
    //    presentEditView.layer.cornerRadius = 25;
    presentEditView.layer.shadowColor = [UIColor blackColor].CGColor;
    presentEditView.layer.shadowOffset = CGSizeMake(1.0f, 2.0f);
    presentEditView.layer.shadowOpacity = 0.6f;
    [presentEditView addTarget:_delegate action:@selector(presentEditNoteViewController) forControlEvents:UIControlEventTouchUpInside];
    //    presentEditView.backgroundColor = [UIColor colorWithRed:0.2078 green:0.5882 blue:0.8588 alpha:1.0];
    presentEditView.backgroundColor = [UIColor colorWithRed:0.2235 green:0.6 blue:0.8549 alpha:1.0];
    [presentEditView setTitle:@"记" forState:UIControlStateNormal];
    [presentEditView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:presentEditView];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor colorWithRed:0.2235 green:0.6 blue:0.8549 alpha:1.0] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(SCREEN_WIDTH - 35, 0, 25, 25);
    searchButton.center = CGPointMake(searchButton.center.x, 35);
    [searchButton addTarget:_delegate action:@selector(displaySearchView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchButton];
    //    ➞
}

@end
