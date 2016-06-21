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
#import "ProfileSliderMenuButton.h"
#import "EditNoteViewController.h"
#import "BottomView.h"

#import <MessageUI/MessageUI.h>
#import <ENSDKAdvanced.h>
#import <ENSDK.h>
#import <EDAM.h>
#import "SearchViewController.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController () <SliderButtonAction, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) ProfileSliderMenu *profileMenu;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view, typically from a nib.
    self.title = @"便签";
    
    [self createMainView];
    [self initNavigationItems];
    [self addGuesture];
    [self displaySearchView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

/**
 *  @brief 添加手势
 */
- (void) addGuesture{
    
    UIScreenEdgePanGestureRecognizer *edgePanGuesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgePanGuesture.maximumNumberOfTouches = 1;
    edgePanGuesture.minimumNumberOfTouches = 1;
    edgePanGuesture.edges = UIRectEdgeLeft;
    edgePanGuesture.delegate = self;
    [self.view addGestureRecognizer:edgePanGuesture];
}

# pragma mark 子视图初始化
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
    [self.view addSubview:blurView];
    
    BYNCollectionFlowView *collectionView = [[BYNCollectionFlowView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
    collectionView.containedVC = self;
    [self.view addSubview:collectionView];
    
    _profileMenu = [[ProfileSliderMenu alloc]init];
    _profileMenu.delegate = self;
    
    // 底部的子视图
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64) andVC:self];
    [self.view addSubview:bottomView];
}

# pragma mark 手势，按钮target
- (void)profile:(UIButton *)sender {
	
    [_profileMenu triggle];
}

- (void)edgePan: (UIScreenEdgePanGestureRecognizer *)gr {
    
    if (gr.state == UIGestureRecognizerStateEnded){
        
        [_profileMenu triggle];
    }
}

# pragma mark 弹出编辑视图
- (void)presentEditNoteViewController{
	
    EditNoteViewController *editNote = nil;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Edit" bundle:[NSBundle mainBundle]];
    editNote = [sb instantiateViewControllerWithIdentifier:@"editViewController"];
    [self presentViewController:editNote animated:YES completion:nil];
}

#pragma mark  侧边栏按钮事件代理

// 连接印象笔记
- (void)linkToEverNote: (ProfileSliderMenuButton *) sender {
    
    ENSession *session = [ENSession sharedSession];
    if (session.isAuthenticated) {
        
        [_profileMenu triggle];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"logoutTitle", nil) message:NSLocalizedString(@"logoutMessage", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirmLogOut", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [session unauthenticate];
            [sender setStatus:SliderButtonNotActive];
            [sender setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
            [_profileMenu triggle];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [_profileMenu triggle];
        }];
        [alert addAction:confirm];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    [session authenticateWithViewController:self preferRegistration:NO completion:^(NSError *error) {
        if (error) {
            // authentication failed
            // show an alert, etc
            // ...
            NSLog(@"印象笔记绑定失败");
            [sender setStatus:SliderButtonNotActive];
            [sender setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
            [_profileMenu triggle];
        } else {
            // authentication succeeded
            // do something now that we're authenticated
            // ...
            NSLog(@"印象笔记绑定成功");
            [sender setStatus:SliderButtonActive];
            [sender setTitle:NSLocalizedString(@"logout", nil) forState:UIControlStateNormal];
            [_profileMenu triggle];
        }
    }];
    [_profileMenu triggle];
}

// feedback
- (void)sendEmailAction
{
    [_profileMenu triggle];
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    
    [mailCompose setMailComposeDelegate:self];
    [mailCompose setSubject:@"Feedback"];
    [mailCompose setToRecipients:@[@"admin@qq.com"]];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [_profileMenu triggle];
    }];
}

// search
- (void)displaySearchView{
    
    SearchViewController *searchViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
//    [_profileMenu triggle];
//    [self presentViewController:searchViewController animated:YES completion:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
}
@end
