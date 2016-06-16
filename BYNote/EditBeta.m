//
//  EditBeta.m
//  BYNote
//
//  Created by cby on 16/6/16.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "EditBeta.h"

@interface EditBeta ()

@property (strong, nonatomic) UITextView *textView;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, strong) NSTextStorage *textStorage;

@end

@implementation EditBeta

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect textViewRect = CGRectInset(self.view.bounds, 10.0, 20.0);
    _textView = [[UITextView alloc] initWithFrame:textViewRect
                                    textContainer:_textContainer];
//    _textView.text = @"我 I asdfjzidijfoiaejf";
    
    [self.view addSubview:_textView];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
    NSLayoutManager *layoutMnage = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutMnage];

    
}

- (void) markWord:(NSString*)word inTextStorage:(NSTextStorage*)textStorage
{
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:word
                                  options:0 error:nil];
    
    NSArray *matches = [regex matchesInString:_textView.text
                                      options:0
                                        range:NSMakeRange(0, [_textView.text length])];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        [textStorage addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:matchRange];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
