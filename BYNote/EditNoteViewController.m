//
//  EditNoteViewController.m
//  BYNote
//
//  Created by cby on 16/6/12.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "EditNoteViewController.h"
#import "YYText.h"
#import "UIView+YYAdd.h"
#import "ToDoButton.h"
#import "CoreDataManager.h"
#import "Note.h"
#import "SyncNoteManager.h"
#import "BYTextView.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

typedef enum buttonName{
    
    listButton = 100,
    undoButton,
    redoButton,
    hideKeyboardButton,
    saveButton,
    closeButton
}buttonName;

@interface EditNoteViewController () <YYTextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) BYTextView *textView;
//@property (strong, nonatomic) YYTextView *textView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *bottomCenterView;
// 当前光标的位置
@property (assign, nonatomic) NSRange currentCursorRange;
// 文本改变时，光标的偏移值
@property (assign, nonatomic) NSInteger cursorOffset;
@property (assign, nonatomic) CGFloat keyboardHeight;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSMutableArray *todoButtonList;

@end

@implementation EditNoteViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _todoButtonList = [[NSMutableArray alloc] init];
    [self initSubViews];
    [self createTextView];
    [self createBottomView];
    _context = [[CoreDataManager shareCoreDataManager] managedObjectContext];
    if (_note) {
        
//        [self loadContent];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _cursorOffset = 0;
    _keyboardHeight = 0;
}

# pragma mark  初始化一些其他的子视图
- (void) initSubViews{
    
    self.view.backgroundColor = [UIColor colorWithRed:0.8672 green:0.8672 blue:0.8672 alpha:1.0];
    _weekLabel.textColor = [UIColor colorWithRed:0.2507 green:0.247 blue:0.2544 alpha:0.8];
    _dateLabel.textColor = [UIColor colorWithRed:0.2507 green:0.247 blue:0.2544 alpha:0.8];
    _weekLabel.text = NSLocalizedString(@"Sat", nil);
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}
/**
 *  @brief 添加 textView
 */
- (void) createTextView{
    
    _textView = [[BYTextView alloc] initWithNote:_note andFrame:self.view.bounds];
    _textView.top += 60.0f;
    _textView.width -= 20.0f;
    _textView.left += 10.0f;
    _textView.height -= 60.0f;


    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
}

// 添加底部视图
- (void) createBottomView{
    
    CGFloat buttonWidth = 30;
    NSArray *buttonNames = @[@"列表", @"undo", @"redo", @"hide", @"save", @"cancel"];
    NSArray *buttonImages = @[[UIImage imageNamed:@"list"],
                              [UIImage imageNamed:@"undo"],
                              [UIImage imageNamed:@"redo"],
                              [UIImage imageNamed:@"down"],
                              [UIImage imageNamed:@"save"],
                              [UIImage imageNamed:@"cancel"]];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - buttonWidth, SCREEN_WIDTH, buttonWidth)];
    _bottomView.backgroundColor = [UIColor clearColor];
    _bottomCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4 * buttonWidth, buttonWidth)];
    _bottomCenterView.center = CGPointMake(_bottomView.center.x, _bottomCenterView.center.y);
    [_bottomView addSubview:_bottomCenterView];
    
    for (int i = 0; i < buttonNames.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect rect = CGRectMake(0 + i * buttonWidth, 0, buttonWidth, buttonWidth);
        [button setImage:buttonImages[i] forState:UIControlStateNormal];
        [button setTitle:buttonNames[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.tag = listButton + i;
        [button addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
        if (button.tag < saveButton) {
            
            [_bottomCenterView addSubview:button];
        }
        if (button.tag == closeButton) {
           
            rect = CGRectMake(0, 0, buttonWidth, buttonWidth);
            rect = CGRectInset(rect, 2, 2);
            [_bottomView addSubview:button];
        }
        if (button.tag == saveButton) {
            
            rect = CGRectMake(SCREEN_WIDTH - buttonWidth, 0, buttonWidth, buttonWidth);
            [_bottomView addSubview:button];
        }
        rect = CGRectInset(rect, 3, 3);
        button.frame = rect;
    }
    [self.view addSubview:_bottomView];
}

# pragma mark 按钮事件
- (void) buttonActions: (UIButton *)sender{
    
    switch (sender.tag) {
        case listButton:
            [self addToDo:sender];
            break;
        case undoButton:
            [_textView performSelector:@selector(undo)];
            break;
        case redoButton:
            [_textView performSelector:@selector(redo)];
            break;
        case hideKeyboardButton:
            [self hideOrShowKeyboard:sender];
            break;
        case saveButton:
            [self saveContent];
            break;
        case closeButton:
            [self closeView];
            break;
        default:
            break;
    }
}

- (void) hideOrShowKeyboard: (UIButton *) sender{
    
    if (sender.selected) {
        
        [_textView becomeFirstResponder];
    }else{
        
        [_textView resignFirstResponder];
    }
}

- (void)closeView{
    
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveContent{
    
    [_textView saveContent];
    [self dismissViewControllerAnimated:YES completion:nil];
//    SyncNoteManager *manager = [[SyncNoteManager alloc] init];
//    [manager createNoteInAppNotebook];
}

- (void)keyBoardShow: (NSNotification *) notification {
	
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    _keyboardHeight = keyboardFrame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
       
        _textView.height -= _keyboardHeight + _bottomView.height;
        _bottomView.top -= _keyboardHeight;
        for (UIButton *b in _bottomCenterView.subviews) {
            
            if (b.tag == hideKeyboardButton) {
                
                b.transform = CGAffineTransformIdentity;
                b.selected = NO;
            }
        }
    }];
}

- (void) keyBoardHide: (NSNotification *) notification{
    
    if (_textView.height + _keyboardHeight + 60 > SCREEN_HEIGHT) {
        
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        
        _textView.height += _keyboardHeight + _bottomView.height;
        _bottomView.top += _keyboardHeight;
        for (UIButton *b in _bottomCenterView.subviews) {
            
            if (b.tag == hideKeyboardButton) {
                
                CGAffineTransform transition = CGAffineTransformMakeRotation(M_PI);
                b.transform = transition;
                b.selected = YES;
            }
        }
    }];
}

- (void) addToDo:(UIButton *) sender{
    
    _currentCursorRange = _textView.selectedRange;
    NSAttributedString *text = [_textView addToDoButton: _currentCursorRange.location + _currentCursorRange.length
                                 andAttributedText:_textView.attributedText
                                       andSelected:NO];
    _textView.attributedText = text;
    _textView.typingAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Heiti SC" size:FONT_SIZE]};
}




@end
