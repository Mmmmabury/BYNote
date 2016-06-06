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

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@property (nonatomic, strong) ProfileSliderMenu *profileMenu;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view, typically from a nib.
    self.title = @"便签";
    self.view.backgroundColor = [UIColor colorWithRed:0.0039 green:0.0863 blue:0.2275 alpha:1.0];
    
    [self createMainView];
    [self initNavigationItems];

}

/**
 *  @brief 初始化导航栏中的 items
 */
- (void) initNavigationItems{
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"个人设置" style:UIBarButtonItemStylePlain target:self action:@selector(profile:)];
    [leftButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *addNoteButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
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
    
    BYNCollectionFlowView *collectionView = [[BYNCollectionFlowView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    collectionView.backgroundColor = [UIColor clearColor];
    [blurView addSubview:collectionView];
    //    [vibrancyView addSubview:collectionView];
    //    self.navigationController.navigationBarHidden = YES;
    _profileMenu = [[ProfileSliderMenu alloc]init];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)profile:(UIBarButtonItem *)sender {
	
    [_profileMenu triggle];
}

@end
