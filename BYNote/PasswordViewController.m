//
//  PasswordViewController.m
//  BYNote
//
//  Created by cby on 16/6/24.
//  Copyright © 2016年 cby. All rights reserved.
//

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PASSWORD_NUMBER 4



#import "PasswordViewController.h"

@interface PasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordFieldView;
@property (strong, nonatomic) UIView *passwordImageView;
@property (weak, nonatomic) IBOutlet UILabel *hitText;
@property (strong, nonatomic) NSString *firstPassword;
@property (assign, nonatomic) NSInteger statues;
@property (strong, nonatomic) NSTimer *timer;
@property (copy, nonatomic) completed completedBlock;

@end

@implementation PasswordViewController

+ (instancetype) pwLockWithCompletedBlock: (completed) block andStatus: (PasswordControllerStatues) status{
    
    PasswordViewController *vc = [[PasswordViewController alloc]initWithNibName:@"PasswordViewController"
                                                                         bundle:[NSBundle mainBundle]];
    if (vc) {
        
        vc.completedBlock = block;
        vc.statues = status;
    }
    return vc;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [_passwordFieldView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSubViews];
    _hitText.font = [UIFont fontWithName:@"Heiti SC" size:20.0f];
    if (_statues == ClosePasswordLock) {
        
        _hitText.text = @"验证密码来关闭密码锁";
    }
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void) viewWillAppear:(BOOL)animated{
    
    [_passwordFieldView becomeFirstResponder];
}

// 初始化子视图
- (void) initSubViews{
    
    self.navigationController.navigationBarHidden = NO;
    _passwordFieldView.hidden = YES;
    _passwordFieldView.delegate = self;
    CGFloat width = (SCREEN_WIDTH - 4) / PASSWORD_NUMBER;
    _passwordImageView = [[UIView alloc] initWithFrame:CGRectMake(2, 0, SCREEN_WIDTH - 4, width)];
    _passwordImageView.center = CGPointMake(_passwordImageView.center.x, self.view.center.y);
    _passwordImageView.top -= 50.0f;
    for (int i = 0; i < PASSWORD_NUMBER; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, width)];
        button.frame = CGRectInset(button.frame, 2, 2);
        button.userInteractionEnabled = NO;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = 4.0f;
        button.tag = 100 + i;
        [button setImage:[UIImage imageNamed:@"black-square"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"black-square-2"] forState:UIControlStateSelected];
        button.selected = NO;
        [_passwordImageView addSubview:button];
    }
    [self.view addSubview:_passwordImageView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger textLength = textField.text.length;
    if (string.length != 0) {
        
        textLength++;
    }
    if (textLength > 4) {
        
        return NO;
    }
    UIButton *button = [_passwordImageView viewWithTag:99 + textLength];
    button.selected = !button.selected;
    if (textLength == 4) {
        
        if (_timer) {
            
            [_timer invalidate];
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(inputDidEnd) userInfo:nil repeats:NO];
    }
    if (textLength > 4) {
        
        return NO;
    }
    return YES;
}

# pragma mark 已经输入4位密码
- (void) inputDidEnd{
    
    BOOL result = NO;
    // 关闭密码锁
    if (_statues == ClosePasswordLock) {
        
        result = [self closeLock];
    }else if (_statues == OpenPasswordLock){
        // 开启密码锁
        
         result = [self openLock];
    }else if (_statues == VerifyPasswordLock){
        
        result = [self authPassword];
    }
    if (result) {
        
        [_passwordFieldView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark 开启和关闭密码锁
- (BOOL) closeLock{
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if ([password isEqualToString:_passwordFieldView.text]) {
        
        if (_completedBlock) {
            
            _completedBlock();
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
        return YES;
    }else{
        
        _hitText.text = @"密码输入错误";
        [self clearPassword];
    }
    return NO;
}

- (BOOL) openLock{
    
    if (_firstPassword.length == 0) {
        
        // 开始第二次输入密码
        _hitText.text = @"请再次输入密码";
        _firstPassword = _passwordFieldView.text;
        [self clearPassword];
        return NO;
    }
    
    // 判断是开启密码锁，并判断第二次输入密码是否匹配
    if ([_firstPassword isEqualToString:_passwordFieldView.text]) {
        
        // 第二次匹配成功
        if (_completedBlock) {
            
            _completedBlock();
        }
        [[NSUserDefaults standardUserDefaults] setObject:_passwordFieldView.text forKey:@"password"];
        return YES;
    }else{
        
        // 第二次输入不匹配
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithString:@"密码输入不符，请再次输入"
                                                attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
        _hitText.attributedText = attributedString;
        [self clearPassword];
        return NO;
    }
}

- (BOOL) authPassword{
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if ([password isEqualToString:_passwordFieldView.text]) {
        
        if (_completedBlock) {
            
            _completedBlock();
        }
    }else{
        
        _hitText.text = @"密码输入错误";
        return NO;
    }
    return YES;
}

- (void) clearPassword{
    
    _passwordFieldView.text = @"";
    for (int i = 0; i < 4; i++) {
        
        UIButton *button = [_passwordImageView viewWithTag:100 + i];
        button.selected = !button.selected;
    }
}

- (IBAction)closeButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
