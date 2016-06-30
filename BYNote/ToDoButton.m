//
//  ToDoButton.m
//  BYNote
//
//  Created by cby on 16/6/20.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ToDoButton.h"

@implementation ToDoButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    
    ToDoButton *button = [super buttonWithType:buttonType];
    if (button) {
        
        [button setImage:[UIImage imageNamed:@"checkYES"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"checkNO"] forState:UIControlStateNormal];
        [button addTarget:button action:@selector(buttonAc) forControlEvents:UIControlEventTouchDown];
    }
    return button;
}

- (void)buttonAc {
	
    self.selected = !self.selected;
}

@end
