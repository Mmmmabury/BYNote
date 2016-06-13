//
//  ViewController.m
//  BYNote
//
//  Created by cby on 16/5/24.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ViewController.h"
#import "BYNCollectionFlowView.h"
#import "ProfileSliderMenu.h"
#import "EditNoteViewController.h"
#import <ENSDKAdvanced.h>
#import <ENSDK.h>
#import <EDAM.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController () <SliderButtonAction>

@property (nonatomic, strong) ProfileSliderMenu *profileMenu;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view, typically from a nib.
    self.title = @"便签";
//    self.view.backgroundColor = [UIColor colorWithRed:0.0039 green:0.0863 blue:0.2275 alpha:1.0];
//    self.view.backgroundColor = [UIColor colorWithRed:0.2235 green:0.6 blue:0.8549 alpha:1.0];
    
    [self createMainView];
    [self initNavigationItems];
//    [self presentEditNoteViewController];
}

/**
 *  @brief 初始化导航栏中的 items
 */
- (void) initNavigationItems{
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"个人设置" style:UIBarButtonItemStylePlain target:self action:@selector(profile:)];
    [leftButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *addNoteButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentEditNoteViewController)];
    addNoteButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addNoteButtonItem;
}

/**
 *  @brief 创建子视图
 */
- (void) createMainView{
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = self.view.bounds;
    
    //    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    //    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
    //    vibrancyView.frame = self.view.bounds;
    //    [blurView.contentView addSubview:vibrancyView];
    
    [self.view addSubview:blurView];
    
    BYNCollectionFlowView *collectionView = [[BYNCollectionFlowView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    //    [vibrancyView addSubview:collectionView];
    //    self.navigationController.navigationBarHidden = YES;
    _profileMenu = [[ProfileSliderMenu alloc]init];
    _profileMenu.delegate = self;
    
    
    // 底部的子视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [profileButton setTitle:@"我" forState:UIControlStateNormal];
    [profileButton setTitleColor:[UIColor colorWithRed:0.2235 green:0.6 blue:0.8549 alpha:1.0] forState:UIControlStateNormal];
    profileButton.frame = CGRectMake(0, 0, 60, 60);
    profileButton.center = CGPointMake(profileButton.center.x, 32);
    [profileButton addTarget:self action:@selector(profile:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:profileButton];
    
    UIButton *presentEditView = [UIButton buttonWithType:UIButtonTypeCustom];
    presentEditView.frame = CGRectMake(0, 0, 50, 50);
    presentEditView.center = CGPointMake(SCREEN_WIDTH / 2, 32);
//    presentEditView.layer.cornerRadius = 25;
    presentEditView.layer.shadowColor = [UIColor blackColor].CGColor;
    presentEditView.layer.shadowOffset = CGSizeMake(1.0f, 2.0f);
    presentEditView.layer.shadowOpacity = 0.6f;
    [presentEditView addTarget:self action:@selector(presentEditNoteViewController) forControlEvents:UIControlEventTouchUpInside];
//    presentEditView.backgroundColor = [UIColor colorWithRed:0.2078 green:0.5882 blue:0.8588 alpha:1.0];
    presentEditView.backgroundColor = [UIColor colorWithRed:0.2235 green:0.6 blue:0.8549 alpha:1.0];
    [presentEditView setTitle:@"记" forState:UIControlStateNormal];
    [presentEditView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:presentEditView];
//    ➞
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)profile:(UIButton *)sender {
	
    [_profileMenu triggle];
}

- (void)presentEditNoteViewController{
	
    EditNoteViewController *editNote = nil;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Edit" bundle:[NSBundle mainBundle]];
    editNote = [sb instantiateViewControllerWithIdentifier:@"editViewController"];
    [self presentViewController:editNote animated:YES completion:nil];
}


//  侧边栏按钮事件代理
- (void)linkToEverNote {
    
    ENSession *session = [ENSession sharedSession];
    if (session.isAuthenticated) {
        
        return;
    }
    [session authenticateWithViewController:self preferRegistration:NO completion:^(NSError *error) {
        if (error) {
            // authentication failed
            // show an alert, etc
            // ...
            NSLog(@"绑定失败");
        } else {
            // authentication succeeded
            // do something now that we're authenticated
            // ...
            NSLog(@"绑定成功");
        }
    }];
}
@end
