//
//  EditBeta2.m
//  BYNote
//
//  Created by cby on 16/6/20.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <YYText/YYText.h>
#import "EditBeta2.h"
#import "ToDoButton.h"
#import "UIView+YYAdd.h"

@interface EditBeta2 ()

@end

@implementation EditBeta2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YYTextView *tv = [[YYTextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tv];
    tv.top += 64;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"hhhhhhh"];
    
    ToDoButton *button = [ToDoButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 19, 19);
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:button contentMode:UIViewContentModeBottom attachmentSize:CGSizeMake(19, 19) alignToFont:[UIFont systemFontOfSize:16.0f] alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:attachment];
    
    tv.attributedText = text;
}

@end
