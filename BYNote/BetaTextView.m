//
//  BetaTextView.m
//  BYNote
//
//  Created by cby on 16/6/20.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "BetaTextView.h"
#import "ToDoButton.h"

@interface BetaTextView () <UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *mutableExclusionPaths;
@end

@implementation BetaTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer{
    
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        
        self.delegate = self;
        _mutableExclusionPaths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
//    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    
    CGRect rect = [self caretRectForPosition:self.selectedTextRange.start];
//    NSLog(@"光标%@", NSStringFromCGRect(rect));
//    CGFloat gap = 12.0f;
    rect.origin.x = 5.0f;
    rect.origin.y += rect.size.height / 2 - 9;
    rect.size.height = 18.0f;
    rect.size.width = 18.0f;
    ToDoButton *button = [ToDoButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
//    [self addSubview:button];
//
    UIBezierPath *path = [UIBezierPath bezierPathWithRect: rect];
    [_mutableExclusionPaths addObject:path];
    self.textContainer.exclusionPaths = [_mutableExclusionPaths copy];
//    NSLog(@"imageViewRect%@", NSStringFromCGRect(rect));
    //    });
    
    if ([text isEqualToString:@"\n"]) {
        
        
    }
    NSLog(@"%@", text);
    //    NSLog(@"%@", NSStringFromRange(range));
    return YES;
}
@end
