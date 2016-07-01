//
//  BYNCollectionCell.m
//  BYNote
//
//  Created by cby on 16/6/4.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "BYNCollectionCell.h"
#import "BYNCELLSIZE.h"
#import "BYTextView.h"

@interface BYNCollectionCell ()

//@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) BYTextView *textView;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) CGRect timeFrame;
@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end
@implementation BYNCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _image = nil;
        [self initFrames];
        [self createSubViews];
    }
    return self;
}

- (void)prepareForReuse{
    
    _image = nil;
    [_textView removeFromSuperview];
    _textView = nil;
}

- (void) initFrames{
    
    _textFrame = self.bounds;
    _textFrame.origin.x += 10.0;
    _textFrame.origin.y += 0;
    _textFrame.size.width -= 20.0;
    _textFrame.size.height -= timeLabelHeight + 0;
    
    _timeFrame = CGRectMake(0, self.bounds.size.height - timeLabelHeight - 10, self.bounds.size.width - 10, timeLabelHeight);
}

- (void) createSubViews{
    
    _timeLabel = [[UILabel alloc] initWithFrame:_timeFrame];
    _timeLabel.text = @"06-01 10:10";
    _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.alpha = 0.8;
    //        timeLabel.backgroundColor = [UIColor colorWithRed:0.1961 green:0.3176 blue:0.4353 alpha:1.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:0.2507 green:0.247 blue:0.2544 alpha:0.8];
    [self.contentView addSubview:_timeLabel];
    
}

- (void)setNote:(Note *)note{
    
    _note = note;
    self.textView.note = note;
}

- (BYTextView *)textView{
    
    if (!_textView) {
        
        _textView = [[BYTextView alloc] initWithNote:nil andFrame:_textFrame];
        _textView.editable = NO;
        _textView.userInteractionEnabled = NO;
        [self.contentView addSubview:_textView];
    }
    return _textView;
}

/**
 *  @brief 当被复用时要重新计算子视图的 frame
 */
- (void)setItemFrame:(CGRect)itemFrame{
    
    [self initFrames];
    self.textView.frame = _textFrame;
    self.timeLabel.frame = _timeFrame;
}

@end

