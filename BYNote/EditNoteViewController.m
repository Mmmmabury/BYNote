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

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface EditNoteViewController () <YYTextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) YYTextView *textView;
@property (strong, nonatomic) UIView *bottomView;
// 当前光标的位置
@property (assign, nonatomic) NSRange currentCursorRange;
// 文本改变时，光标的偏移值
@property (assign, nonatomic) NSInteger cursorOffset;
@property (assign, nonatomic) CGFloat keyboardHeight;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSMutableArray *aaaa;

@end

@implementation EditNoteViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _aaaa = [[NSMutableArray alloc] init];
    [self initSubViews];
    [self createTextView];
    [self createBottomView];
    _context = [[CoreDataManager shareCoreDataManager] managedObjectContext];
    if (_note) {
        
        [self loadContent];
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
    
    _textView = [[YYTextView alloc] initWithFrame:self.view.bounds];
    _textView.top += 60.0f;
    _textView.width -= 20.0f;
    _textView.left += 10.0f;
    _textView.height -= 60.0f;
    _textView.font = [UIFont systemFontOfSize:FONT_SIZE];
    _textView.allowsCopyAttributedString = NO;
    _textView.allowsPasteAttributedString = YES;
    _textView.allowsPasteImage = NO;
    _textView.showsVerticalScrollIndicator = YES;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.delegate = self;
    _textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
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
    
//    [_textView resignFirstResponder];
    for (ToDoButton *b in _aaaa) {
        
        b.selected = YES;
    }
}

- (void)closeView:(UIButton *)sender {
    
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    NSAttributedString *text = [self addToDoButton: _currentCursorRange.location + _currentCursorRange.length
                                 andAttributedText:_textView.attributedText
                                       andSelected:NO];
    _textView.attributedText = text;
    //    _textView.selectedRange = NSMakeRange(text.length + 2, 0);
    _textView.typingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]};
}

# pragma mark 添加 todo
// 添加 todo 按钮
- (NSAttributedString *)addToDoButton:(NSInteger) index andAttributedText: (NSAttributedString *) attext andSelected: (BOOL) selected{

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:attext];
    
    ToDoButton *toDoButton = [ToDoButton buttonWithType:UIButtonTypeCustom];
    toDoButton.frame = CGRectMake(0, 0, 19, 19);
    toDoButton.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    toDoButton.selected = selected;
    [_aaaa addObject:toDoButton];
    NSMutableAttributedString *todo =
    [NSMutableAttributedString yy_attachmentStringWithContent:toDoButton
                                                  contentMode:UIViewContentModeBottom
                                               attachmentSize:toDoButton.size
                                                  alignToFont:[UIFont systemFontOfSize:FONT_SIZE]
                                                    alignment:YYTextVerticalAlignmentBottom];
    // 如果 index 和文本长度相等，则直接加载文本末尾
    if (index == text.length){
    
        [text appendAttributedString:todo];
    }else if (index < text.length){
        
        [text insertAttributedString:todo atIndex:index];
    }
    return [text copy];
//    _textView.attributedText = text;
////    _textView.selectedRange = NSMakeRange(text.length + 2, 0);
//    _textView.typingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]};
}


# pragma mark textView 的代理实现
- (void)textViewDidChange:(YYTextView *)textView{
    
    // 这里我把 YYTextView 中的 setSelectedRange 方法改了一点，如果有问题，点进源码看看
    _textView.selectedRange = NSMakeRange(_currentCursorRange.location + 1 + _cursorOffset, 0);
    _cursorOffset = 0;
    textView.typingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]};
}

// 实现 原行有 todo 按钮时，换行时自动添加 todo 按钮
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    _currentCursorRange = textView.selectedRange;
    // 删除字符
    if (text.length == 0 && range.length == 1) {
        
        _cursorOffset = -1;
    }
    if ([text isEqualToString:@"\n"]) {
        
        NSAttributedString *attributedText = textView.attributedText;
        // 遍历每一行
        [textView.text enumerateSubstringsInRange:NSMakeRange(0, textView.text.length) options:NSStringEnumerationByLines usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            
            NSInteger subStringBeginIndex = substringRange.location;
            NSInteger subStringEndIndex = substringRange.location + substringRange.length;
            NSInteger changeIndex = range.location + range.length;
            
            // 光标所在行是否有 todo 按钮
            if (changeIndex >= subStringBeginIndex && changeIndex <= subStringEndIndex) {
                
                NSString *firstChar = [attributedText yy_plainTextForRange:NSMakeRange(subStringBeginIndex, 1)];
                if ([firstChar isEqualToString:@"\U0000fffc"]) {
                    
                    NSLog(@"行首有 todo 按钮, 添加 todo 按钮");
                    NSAttributedString *text = [self addToDoButton:_currentCursorRange.location andAttributedText:_textView.attributedText andSelected:NO];
                    _textView.attributedText = text;
                    _textView.typingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]};
                    _cursorOffset = 1;
                }else{
                    
                    NSLog(@"行首没有 todo 按钮");
                }
            }
        }];
    }
    
    if ([text isEqualToString:@"\U0000fffc"]) {
        
        _cursorOffset = 1;
    }
    return YES;
}

# pragma mark 加载数据
- (void) loadContent{
    
    NSString *str = _note.content;
    NSArray *status = _note.status;
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
       
        if ([substring isEqualToString:@"\U0000fffc"]) {
           
            [ranges addObject:[NSValue valueWithRange:substringRange]];
        }
    }];
    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithString:str];
    if (ranges.count > 0) {
        
        for (int i = 0; i < ranges.count; i++) {
         
            NSValue *v = ranges[i];
            NSRange range = [v rangeValue];
            NSInteger index = range.location;
            BOOL s = [status[i] boolValue];
            [ms replaceCharactersInRange:range withString:@""];
            ms = [[self addToDoButton:index andAttributedText:ms andSelected:s] mutableCopy];
        }
    }
    [ms addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_SIZE] range:NSMakeRange(0, ms.length)];
    _textView.attributedText = [ms copy];
    _textView.typingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]};
}

- (void) saveContent{
    
    //todo 还要保存 todobutton 的状态
    NSLog(@"%@", NSHomeDirectory());
    NSDate *now = [NSDate date];
    if (!_note) {
        
        NSLog(@"Note 实例不存在，新建 Note 实例");
        _note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:_context];
        _note.create_data = now;
    }
    _note.content = _textView.text;
    _note.changed = @YES;
    _note.update_data = now;
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (int i = 0; i < _aaaa.count; i++) {
        
        ToDoButton *b = _aaaa[i];
        NSNumber *n = [NSNumber numberWithBool:b.selected];
        [a addObject:n];
    }
    _note.status = a;
    [[CoreDataManager shareCoreDataManager] saveContext];
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
