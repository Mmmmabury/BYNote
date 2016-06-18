//
//  EditBeta.m
//  BYNote
//
//  Created by cby on 16/6/16.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "EditBeta.h"

@interface EditBeta () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, strong) NSTextStorage *textStorage;

@end

@implementation EditBeta

- (void)viewDidLoad
{
    [super viewDidLoad];
    // layoutManage --> storage
    // textContainer --> layoutMnage
    
    CGRect textViewRect = CGRectInset(self.view.bounds, 10.0, 20.0);
    _textStorage = [[NSTextStorage alloc] init];
    NSLayoutManager *layoutManage = [[NSLayoutManager alloc] init];
    [_textStorage addLayoutManager:layoutManage];
    
    _textContainer = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
    [layoutManage addTextContainer:_textContainer];
    
    _textView = [[UITextView alloc] initWithFrame:textViewRect
                                    textContainer:_textContainer];
    _textView.font = [UIFont systemFontOfSize:20.0f];
    _textView.text = @"hehheh沃尔法定的设计费lknzdadfeadafdujrifniajrf 爱是科技哦；asdobgieliadkjfhjdbafliuehgdalkjsaebgiulahe";
    _textView.delegate = self;
//    _textView.text = @"我 I asdfjzidijfoiaejf";
//    [self bezierPath];
    
    [self.view addSubview:_textView];
    
//    [_textView.textStorage replaceCharactersInRange:NSMakeRange(0, 5) withString:@"hhhhh"];
    
    [_textStorage beginEditing];
    
    NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle];
    NSMutableParagraphStyle *mParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [mParagraphStyle setParagraphStyle:paragraphStyle];
    mParagraphStyle.lineSpacing = 5.0f;
    
    NSLog(@"%f", paragraphStyle.lineSpacing);
    
    [_textStorage addAttributes:@{
                                  NSForegroundColorAttributeName : [UIColor redColor],
                                  NSFontAttributeName : [UIFont systemFontOfSize:25.0f],
                                  NSParagraphStyleAttributeName : mParagraphStyle
                                  }
                          range:NSMakeRange(0, _textView.text.length)];
    [_textStorage endEditing];
    
}

- (void) bezierPath{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 50, 50)];
    _textView.textContainer.exclusionPaths = @[path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView{
    
    [textView.text enumerateSubstringsInRange:NSMakeRange(0, textView.text.length) options:NSStringEnumerationByLines usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
//        NSLog(@"substringRange:%@", NSStringFromRange(substringRange));
//        NSLog(@"%@", NSStringFromRange(enclosingRange));
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CGRect rect = [_textView caretRectForPosition:_textView.selectedTextRange.start];
        CGFloat inset = 12.0f;
        rect.origin.x = 5.0f;
        rect.origin.y += inset / 2 + 2;
        rect.size.height -= inset;
        rect.size.width = rect.size.height;
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = [UIColor blackColor];
        [_textView addSubview:view];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect: rect];
        _textView.textContainer.exclusionPaths = @[path];
        NSLog(@"%@", NSStringFromCGRect(rect));
    });
    
    if ([text isEqualToString:@"\n"]) {
        
//        NSLog(@"dd");
    }
//    NSLog(@"%@", text);
//    NSLog(@"%@", NSStringFromRange(range));
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
