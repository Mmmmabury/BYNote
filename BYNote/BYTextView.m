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
    _cursorOffset = 0;
    _changed = NO;
    _todoButtonList = [[NSMutableArray alloc] init];
    if (note) {
        
        self.note = note;
    }
    YYTextDebugOption *debugOptions = [YYTextDebugOption new];
    debugOptions.baselineColor = [UIColor redColor];
    debugOptions.CTFrameBorderColor = [UIColor redColor];
    debugOptions.CTLineFillColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:0.180];
    debugOptions.CGGlyphBorderColor = [UIColor colorWithRed:1.000 green:0.524 blue:0.000 alpha:1.00];
    
    [YYTextDebugOption setSharedDebugOption:debugOptions];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 2.0f;
//    paragraph.maximumLineHeight = 10.0f;
//    paragraph.minimumLineHeight = 10.0f;
    self.typingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE],
                              NSParagraphStyleAttributeName : paragraph};
    return self;
}

- (void) setupConfig{
    
    
    self.delegate = self;
    self.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.allowsCopyAttributedString = NO;
    self.allowsPasteAttributedString = YES;
    self.allowsPasteImage = NO;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
}

# pragma mark 加载内容
// 如果有 note 传入，则加载 note 中的内容
- (void) loadContent{
    
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
    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithString:_content];
    if (ranges.count > 0) {
        
        for (int i = 0; i < ranges.count; i++) {
            
            NSValue *v = ranges[i];
            NSRange range = [v rangeValue];
            NSInteger index = range.location;
            NSNumber *selectNum = _status[i];
            BOOL selected = [selectNum boolValue];
            [ms replaceCharactersInRange:range withString:@""];
            ms = [[self addToDoButton:index andAttributedText:ms andSelected:selected] mutableCopy];
        }
    }
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 2.0f;
    paragraph.maximumLineHeight = 18.0f;
    paragraph.minimumLineHeight = 10.0f;
    [ms addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_SIZE] range:NSMakeRange(0, ms.length)];
    [ms addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, ms.length)];
    self.attributedText = ms;
}

# pragma mark 添加 todo 按钮
- (NSAttributedString *)addToDoButton:(NSInteger) index
                    andAttributedText: (NSAttributedString *) attext
                          andSelected: (BOOL) selected{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:attext];
    ToDoButton *toDoButton = [ToDoButton buttonWithType:UIButtonTypeCustom];
    toDoButton.frame = CGRectMake(0, 0, 19, 19);
    toDoButton.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    toDoButton.selected = selected;
    // 将 todobutton 添加到数组中
    [_todoButtonList addObject:toDoButton];
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
    text.yy_lineSpacing = 0.0f;
    NSRange r = NSMakeRange(0, 5);
    NSLog(@"%@", [text attributesAtIndex:4 effectiveRange:&r]);
    return [text copy];
}


# pragma mark textView 的代理实现
- (void)textViewDidChange:(YYTextView *)textView{
    
    // 这里我把 YYTextView 中的 setSelectedRange 方法改了一点，如果有问题，点进源码看看
    self.selectedRange = NSMakeRange(_currentCursorRange.location + 1 + _cursorOffset, 0);
    _cursorOffset = 0;
    _changed = YES;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 2.0f;
    self.typingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE],
                              NSParagraphStyleAttributeName : paragraph};
}

// 实现 原行有 todo 按钮时，换行时自动添加 todo 按钮
- (BOOL)textView:(YYTextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    
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
                    NSAttributedString *text = [self addToDoButton:_currentCursorRange.location andAttributedText:self.attributedText andSelected:NO];
                    self.attributedText = text;
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

# pragma mark 保存内容
- (void) saveContent{
    
    if (self.text.length == 0) {
        
        return;
    }
    NSLog(@"%@", NSHomeDirectory());
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
    [self loadContent];
}



@end
