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
#import <LocalAuthentication/LocalAuthentication.h>
#import "SearchViewController.h"
#import "PasswordViewController.h"
#import "UIView+YYAdd.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController () <SliderButtonAction, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>

{
    CGRect _bottomViewHideFrame;
    CGRect _bottomViewShowFrame;
}
@property (nonatomic, strong) ProfileSliderMenu *profileMenu;
@property (nonatomic, strong) BottomView *bottomView;
@property (strong, nonatomic) BYNCollectionFlowView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view, typically from a nib.
    self.title = @"便签";
    
    [self createMainView];
    [self initNavigationItems];
    [self addGuesture];
    [self addNotifications];
//    [self displaySearchView];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [_collectionView reloadData];
}

// 添加重要通知
- (void) addNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomViewShow) name:FLOWVIEW_DOWN_SCROLL_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomViewHide) name:FLOWVIEW_UP_SCROLL_NOTI object:nil];
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
    
    _collectionView = [[BYNCollectionFlowView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
    [self.view addSubview:_collectionView];
    
    _profileMenu = [[ProfileSliderMenu alloc]init];
    _profileMenu.delegate = self;
    
    // 底部的子视图
    _bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64) andVC:self];
    [self.view addSubview:_bottomView];
    _bottomViewShowFrame = _bottomView.frame;
    _bottomViewHideFrame = _bottomViewShowFrame;
    _bottomViewHideFrame.origin.y = _bottomViewHideFrame.origin.y + 70.0;
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
    
    [_profileMenu triggle];
    ENSession *session = [ENSession sharedSession];
    if (session.isAuthenticated) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"logoutTitle", nil) message:NSLocalizedString(@"logoutMessage", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"confirmLogOut", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [session unauthenticate];
            [sender setStatus:SliderButtonNotActive];
            [sender setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"取消连接印象笔记");
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
        } else {
            // authentication succeeded
            // do something now that we're authenticated
            // ...
            NSLog(@"印象笔记绑定成功");
            [sender setStatus:SliderButtonActive];
            [sender setTitle:NSLocalizedString(@"logout", nil) forState:UIControlStateNormal];
        }
    }];
}

// feedback
- (void)sendEmailAction
{
    [_profileMenu triggle];
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    
    [mailCompose setMailComposeDelegate:self];
    [mailCompose setSubject:@"Feedback"];
    [mailCompose setToRecipients:@[@"yuntechs@outlook.com"]];
    
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
    [_profileMenu triggle];
//    [self presentViewController:searchViewController animated:YES completion:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

// 指纹
- (void) authenticationWithFinger: (ProfileSliderMenuButton *) sender{
    
    NSString *localizedStr = nil;
    if (sender.status == SliderButtonNotActive) {
        
       localizedStr = @"fingerStart";
    }else if(sender.status == SliderButtonActive){
        
       localizedStr = @"fingerClose";
    }
    
    [_profileMenu triggle];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"朕知道了" style:UIAlertActionStyleDefault handler:nil];
        
    if ([UIDevice currentDevice].systemVersion.floatValue <= 8.0) {
        
        alert.message = @"系统版本太低，不支持指纹锁";
        [alert addAction:yesAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    LAContext *context = [LAContext new];
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        
        NSLog(@"对不起, 指纹识别技术暂时不可用");
        alert.message = @"对不起, 指纹识别技术暂时不可用";
        [alert addAction:yesAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    // 开始使用指纹识别
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(localizedStr, nil) reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            NSLog(@"指纹识别成功");
            // 指纹识别成功，回主线程更新UI,弹出提示框
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (sender.status == SliderButtonNotActive) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"authenticationWithBiometrics"];
                    alert.message = @"指纹识别成功, 指纹锁已经打开";
                    sender.status = SliderButtonActive;
                }else if(sender.status == SliderButtonActive){
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"authenticationWithBiometrics"];
                    alert.message = @"指纹识别成功, 指纹锁已经关闭";
                    sender.status = SliderButtonNotActive;
                }
                [alert addAction:yesAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
        if (error) {
            
            if (error.code == -2) {
                
                NSLog(@"用户取消了操作");
            } else {
                
                NSLog(@"指纹锁发生错误: %@",error);
            }
        }
    }];
    
}

- (void)launchWithPassword:(ProfileSliderMenuButton *)sender{
    
    // 判断开启或者关闭密码锁
    int lockStatus = 0;
    if (sender.status == SliderButtonActive) {
        
        lockStatus = ClosePasswordLock;
    }else{
        
        lockStatus = OpenPasswordLock;
    }
    PasswordViewController *vc = [PasswordViewController pwLockWithCompletedBlock:^{
        
        sender.status = sender.status ^ 0x1;
    }andStatus:lockStatus];
    [_profileMenu triggle];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)bottomViewHide {
	
    [UIView animateWithDuration:0.2 animations:^{
        
        _bottomView.frame = _bottomViewHideFrame;
    }];
}

- (void)bottomViewShow {
	
    [UIView animateWithDuration:0.2 animations:^{
        
        _bottomView.frame = _bottomViewShowFrame;
    }];
}

@end
