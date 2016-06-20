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

@interface EditNoteViewController ()

@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self createTextView];
}

- (void) createTextView{
    
    YYTextView *textView = [[YYTextView alloc] initWithFrame:self.view.bounds];
    textView.top += 20.0f;
    textView.font = [UIFont systemFontOfSize:25.0f];
    [self.view addSubview:textView];
}


- (IBAction)closeView:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
