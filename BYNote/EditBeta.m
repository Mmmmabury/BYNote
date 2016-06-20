//
//  EditBeta.m
//  BYNote
//
//  Created by cby on 16/6/16.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <YYText/YYText.h>
#import "EditBeta.h"
#import "BetaTextView.h"
#import "ToDoButton.h"

@interface EditBeta () <UITextViewDelegate>

@property (strong, nonatomic) BetaTextView *textView;
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
    
    _textView = [[BetaTextView alloc] initWithFrame:textViewRect
                                    textContainer:_textContainer];
    _textView.font = [UIFont systemFontOfSize:20.0f];
    _textView.text = @"hehheh沃尔法定的设计费lknzdadfeadafdujrifniajrf 爱是科技哦；asdobgieliadkjfhjdbafliuehgdalkjsaebgiulahe";
//    _textView.delegate = self;
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

    ToDoButton *button = [ToDoButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 19, 19);
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:button
                                                                                          contentMode:UIViewContentModeBottom
                                                                                       attachmentSize:CGSizeMake(19, 19)
                                                                                          alignToFont:[UIFont systemFontOfSize:25.0f]
                                                                                            alignment:YYTextVerticalAlignmentCenter];
    [_textStorage insertAttributedString:attachment atIndex:5];
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

@end
