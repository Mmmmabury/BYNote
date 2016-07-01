//
//  BYTextView.m
//  BYNote
//
//  Created by cby on 16/6/29.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "BYTextView.h"
#import "ToDoButton.h"
#import "CoreDataManager.h"

#define THE_FONT [UIFont fontWithName:@"Heiti SC" size:FONT_SIZE]

@interface BYTextView ()<YYTextViewDelegate>

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSArray *status;
@property (assign, nonatomic) BOOL changed;

// 当前光标的位置
@property (assign, nonatomic) NSRange currentCursorRange;
// 文本改变时，光标的偏移值
@property (assign, nonatomic) NSInteger cursorOffset;
@end

@implementation BYTextView

- (instancetype) initWithNote: ( Note *) note
                     andFrame: (CGRect) frame{

    self = [super initWithFrame:frame];
    if (!self) {
        
        return nil;
    }
    [self setupConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    if (note) {
        
        self.note = note;
    }
    self.typingAttributes = @{NSFontAttributeName : THE_FONT};
    self.selectedRange = NSMakeRange(0, 0);
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setupConfig{
    
    _cursorOffset = 0;
    _changed = NO;
    _todoButtonList = [[NSMutableArray alloc] init];
    
    self.delegate = self;
    self.font = THE_FONT;
    self.allowsCopyAttributedString = YES;
    self.allowsPasteAttributedString = YES;
    self.allowsPasteImage = NO;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 21;
    self.linePositionModifier = modifier;
}

# pragma mark 加载内容
// 如果有 note 传入，则加载 note 中的内容
- (void) loadContent{
   
    NSAttributedString *ms = [[NSAttributedString alloc] initWithString:_content attributes:@{NSFontAttributeName: THE_FONT}];
    self.attributedText = [self parserContent:ms];
    NSDate *createData = _note.create_data;
    NSDateFormatter *formatter = 
}

- (NSAttributedString *) parserContent: (NSAttributedString *) str{
    
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    [_content enumerateSubstringsInRange:NSMakeRange(0, _content.length)
                                 options:NSStringEnumerationByComposedCharacterSequences
                              usingBlock:^(NSString * _Nullable substring,
                                           NSRange substringRange,
                                           NSRange enclosingRange,
                                           BOOL * _Nonnull stop) {
                                  
                                  if ([substring isEqualToString:@"\U0000fffc"]) {
                                      
                                      [ranges addObject:[NSValue valueWithRange:substringRange]];
                                  }
                              }];
    NSMutableAttributedString *ms = [str mutableCopy];
    if (ranges.count > 0) {
        
        for (int i = 0; i < ranges.count; i++) {
            
            NSValue *v = ranges[i];
            NSRange range = [v rangeValue];
            NSInteger index = range.location;
            BOOL selected = NO;
            if (i < _status.count) {
                
                NSNumber *selectNum = _status[i];
                selected = [selectNum boolValue];
            }
            [ms replaceCharactersInRange:range withString:@""];
            ms = [[self addToDoButton:index andAttributedText:ms andSelected:selected] mutableCopy];
        }
    }
    return ms;
}

# pragma mark 添加 todo 按钮
- (NSAttributedString *)addToDoButton:(NSInteger) index
                    andAttributedText: (NSAttributedString *) attext
                          andSelected: (BOOL) selected{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:attext];
    ToDoButton *toDoButton = [ToDoButton buttonWithType:UIButtonTypeCustom];
    toDoButton.frame = CGRectMake(0, 0, 19, 19);
    toDoButton.titleLabel.font = THE_FONT;
    toDoButton.selected = selected;
    // 将 todobutton 添加到数组中
    [_todoButtonList addObject:toDoButton];
    NSMutableAttributedString *todo =
    [NSMutableAttributedString yy_attachmentStringWithContent:toDoButton
                                                  contentMode:UIViewContentModeCenter
                                               attachmentSize:toDoButton.size
                                                  alignToFont:THE_FONT
                                                    alignment:YYTextVerticalAlignmentCenter];
    // 如果 index 和文本长度相等，则直接加载文本末尾
    if (index >= text.length){
        
        [text appendAttributedString:todo];
    }else if (index < text.length){
        
        [text insertAttributedString:todo atIndex:index];
    }
    return [text copy];
}


# pragma mark textView 的代理实现
- (void)textViewDidChange:(YYTextView *)textView{
    
    // 这里我把 YYTextView 中的 setSelectedRange 方法改了一点，如果有问题，点进源码看看
    self.selectedRange = NSMakeRange(_currentCursorRange.location + 1 + _cursorOffset, 0);
    _cursorOffset = 0;
    _changed = YES;
    self.typingAttributes = @{NSFontAttributeName : THE_FONT};
}

// 实现 原行有 todo 按钮时，换行时自动添加 todo 按钮
- (BOOL)textView:(YYTextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    
    _currentCursorRange = textView.selectedRange;
    // 如果是删除字符
    if (text.length == 0 && range.length == 1) {
        
        _cursorOffset = -1;
    }
    // 如果输入的是空格，则坚持是否需要添加按钮
    if ([text isEqualToString:@"\n"]) {
        
        [self addTodoButtonInNewLine:textView andRange:range];
    }
    
    if ([text isEqualToString:@"\U0000fffc"]) {
        
        _cursorOffset = 1;
    }
    
    return YES;
}

- (void) addTodoButtonInNewLine: (YYTextView *) textView andRange: (NSRange) range{
    
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
                NSAttributedString *text = [self addToDoButton:_currentCursorRange.location andAttributedText:self.attributedText andSelected:NO];
                NSMutableAttributedString *addSpaceText = [text mutableCopy];
                NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" " attributes: @{NSFontAttributeName : THE_FONT}];
                [addSpaceText appendAttributedString: space];
                self.attributedText = [addSpaceText copy];
                _cursorOffset = 2;
            }else{
                
                NSLog(@"行首没有 todo 按钮");
            }
        }
    }];
}

# pragma mark 保存内容
- (void) saveContent{
    
    if (self.text.length == 0) {
        
        return;
    }
    NSLog(@"HomeDirectory:%@", NSHomeDirectory());
    CoreDataManager *manager = [CoreDataManager shareCoreDataManager];
    NSManagedObjectContext *context = [manager managedObjectContext];
    NSDate *now = [NSDate date];
    if (!_note) {
        
        NSLog(@"Note 实例不存在，新建 Note 实例");
        _note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
        _note.create_data = now;
    }
    _note.content = self.text;
    _note.changed = @YES;
    _note.update_data = now;
    _todoButtonList = [self.todoButtonList copy];
    NSMutableArray *status = [[NSMutableArray alloc] init];
    // 保存 todobutton 的状态
    for (int i = 0; i < _todoButtonList.count; i++) {
        
        ToDoButton *b = _todoButtonList[i];
        NSNumber *n = [NSNumber numberWithBool:b.selected];
        [status addObject:n];
    }
    _note.status = status;
    [[CoreDataManager shareCoreDataManager] saveContext];
    [self resignFirstResponder];
}

# pragma mark setter
- (void)setNote:(Note *)note{
    
    _note = note;
    _content = note.content;
    _status = note.status;
    [_todoButtonList removeAllObjects];
    [self loadContent];
}

# pragma mark 通知
// 进入后台时调用
- (void)enterBackground {
	
    [self resignFirstResponder];
}



@end
