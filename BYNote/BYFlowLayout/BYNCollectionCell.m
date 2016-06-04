//
//  BYNCollectionCell.m
//  BYNote
//
//  Created by cby on 16/6/4.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "BYNCollectionCell.h"

@interface BYNCollectionCell ()

//@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;
@end
@implementation BYNCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        self.textView = [[UITextView alloc] initWithFrame:self.contentView.bounds];
//        self.textView.editable = NO;
//        self.textView.userInteractionEnabled = NO;
//        self.textView.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.textView];
//        self.label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        CGRect frame = self.bounds;
        frame.origin.x += 5;
        frame.size.width -= 10;
        self.label = [[UILabel alloc] initWithFrame:frame];
        self.label.numberOfLines = 0;
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setText:(NSString *)text{
    
//    self.textView.text = text;
//    self.textView.font = [UIFont systemFontOfSize:20.0f];
    self.label.text = text;
    self.label.font = [UIFont systemFontOfSize:20.0f];
}
@end
