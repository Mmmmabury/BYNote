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

@interface EditNoteViewController () <YYTextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) BYTextView *textView;
@property (strong, nonatomic) UIView *bottomView;
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
    NSArray *array = _note.status;
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
    
//    _textView = [[YYTextView alloc] initWithFrame:self.view.bounds];
    _textView = [[BYTextView alloc] initWithNote:_note andFrame:self.view.bounds];
    _textView.top += 60.0f;
    _textView.width -= 20.0f;
    _textView.left += 10.0f;
    _textView.height -= 60.0f;

    [self.view addSubview:_textView];
}

// 添加底部视图
- (void) createBottomView{
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
    _bottomView.backgroundColor = [UIColor clearColor];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(SCREEN_WIDTH - 45, 0, 40, 30);
    [closeButton setTitle:@"关闭" forState: UIControlStateNormal];
    [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(SCREEN_WIDTH - 90, 0, 40, 30);
    [saveButton setTitle:@"保存" forState: UIControlStateNormal];
    [saveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveContent) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *toDoListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toDoListButton.frame = CGRectMake(5, 0, 40, 30);
    [toDoListButton setTitle:@"列表" forState: UIControlStateNormal];
    [toDoListButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [toDoListButton addTarget:self action:@selector(addToDo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeCustom]; undoButton.frame = CGRectMake(5 * 2 + 40, 0, 50, 30);
    [undoButton setTitle:@"undo" forState: UIControlStateNormal];
    [undoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    redoButton.frame = CGRectMake(5 * 3 + 80, 0, 50, 30);
    [redoButton setTitle:@"redo" forState: UIControlStateNormal];
    [redoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [redoButton addTarget:self action:@selector(redo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hideKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideKeyboardButton.frame = CGRectMake(5 * 4 + 120, 0, 50, 30);
    [hideKeyboardButton setTitle:@"收键盘" forState: UIControlStateNormal];
    [hideKeyboardButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [hideKeyboardButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clockButton.frame = CGRectMake(5 * 3 + 80, 0, 50, 30);
    [clockButton setTitle:@"redo" forState: UIControlStateNormal];
    [clockButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [clockButton addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:hideKeyboardButton];
    [_bottomView addSubview:redoButton];
    [_bottomView addSubview:undoButton];
    [_bottomView addSubview:toDoListButton];
    [_bottomView addSubview:closeButton];
    [_bottomView addSubview:saveButton];
    [self.view addSubview:_bottomView];
}

# pragma mark 按钮事件
- (void) undo{
    
    [_textView performSelector:@selector(_undo)];
}

- (void) redo{
    
    [_textView performSelector:@selector(_redo)];
}

- (void) hideKeyboard{
    
    [_textView resignFirstResponder];
}

- (void)closeView:(UIButton *)sender {
    
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
    }];
}

- (void) keyBoardHide: (NSNotification *) notification{
    
    if (_textView.height + _keyboardHeight + 60 > SCREEN_HEIGHT) {
        
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        
        _textView.height += _keyboardHeight + _bottomView.height;
        _bottomView.top += _keyboardHeight;
    }];
}

- (void) addToDo:(UIButton *) sender{
    
    _currentCursorRange = _textView.selectedRange;
    NSAttributedString *text = [_textView addToDoButton: _currentCursorRange.location + _currentCursorRange.length
                                 andAttributedText:_textView.attributedText
                                       andSelected:NO];
    _textView.attributedText = text;
    //    _textView.selectedRange = NSMakeRange(text.length + 2, 0);
    _textView.typingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]};
}

@end
