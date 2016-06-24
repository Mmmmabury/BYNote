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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSubViews];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [_passwordFieldView becomeFirstResponder];
}

- (void) initSubViews{
    
    self.navigationController.navigationBarHidden = NO;
    _passwordFieldView.hidden = YES;
    _passwordFieldView.delegate = self;
    CGFloat width = (SCREEN_WIDTH - 20) / PASSWORD_NUMBER;
    _passwordImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, width)];
    _passwordImageView.center = CGPointMake(_passwordImageView.center.x, self.view.center.y);
    for (int i = 0; i < PASSWORD_NUMBER; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i * width, 0, width, width)];
        button.userInteractionEnabled = NO;
        button.tag = 100 + i;
        [button setImage:[UIImage imageNamed:@"123.JPG"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"12.JPG"] forState:UIControlStateSelected];
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

- (void) inputDidEnd{
    
    if (_firstPassword.length == 0) {
    
        // 开始第二次输入密码
        _hitText.text = @"请再次输入密码";
        _firstPassword = _passwordFieldView.text;
        [self clearPassword];
        return;
    }
    
    // 判断第二次输入密码是否匹配
    if ([_firstPassword isEqualToString:_passwordFieldView.text]) {
        
        // 第二次匹配成功
        switch (_statues) {
            case OpenPasswordLock:
        
                [[NSUserDefaults standardUserDefaults] setObject:@"password" forKey:_passwordFieldView.text];
                break;
            case ClosePasswordLock:
                
                [[NSUserDefaults standardUserDefaults] setObject:@"password" forKey:@""];
                break;
            default:
                break;
        }
        if (_completedBlock) {
            
            _completedBlock();
        }
        [_passwordFieldView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }else{
    
        // 第二次输入不匹配
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithString:@"密码输入不符，请再次输入"
                                                attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
        _hitText.attributedText = attributedString;
        [self clearPassword];
        return;
    }
}

- (void) clearPassword{
    
    _passwordFieldView.text = @"";
    for (int i = 0; i < 4; i++) {
        
        UIButton *button = [_passwordImageView viewWithTag:100 + i];
        button.selected = !button.selected;
    }
}
@end
