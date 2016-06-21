//
//  BYNCollectionCell.m
//  BYNote
//
//  Created by cby on 16/6/4.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "BYNCollectionCell.h"
#import "BYNCELLSIZE.h"

@interface BYNCollectionCell ()

//@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIVisualEffectView *darkBlurView;
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
}

- (void) initFrames{
    
    _textFrame = self.bounds;
    _textFrame.origin.x += 10;
    _textFrame.origin.y += 0;
    _textFrame.size.width -= 20;
    _textFrame.size.height -= timeLabelHeight + 10;
    
    _timeFrame = CGRectMake(0, self.bounds.size.height - timeLabelHeight - 10, self.bounds.size.width - 10, timeLabelHeight);
}

- (void) createSubViews{
    
    if (_image) {
        
    }else{
        self.label = [[UILabel alloc] initWithFrame:_textFrame];
        self.label.numberOfLines = 0;
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont fontWithName:@"monaco" size:20.0f];
        [self.contentView addSubview:self.label];
    }
    
    _timeLabel = [[UILabel alloc] initWithFrame:_timeFrame];
    _timeLabel.text = @"06-01 10:10";
    _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.alpha = 0.8;
    //        timeLabel.backgroundColor = [UIColor colorWithRed:0.1961 green:0.3176 blue:0.4353 alpha:1.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:0.2507 green:0.247 blue:0.2544 alpha:0.8];
    [self.contentView addSubview:_timeLabel];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _darkBlurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _darkBlurView.frame = self.bounds;
    _darkBlurView.hidden = YES;
    [self.contentView insertSubview:_darkBlurView belowSubview:_label];
}

// 点击时背景加深
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    _darkBlurView.hidden = NO;
//}

/**
 *  @brief 点击的时候背景取消加深
 *
 *  @param touches  touch
 *  @param event   事件
 */
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(removeBlur) userInfo:nil repeats:NO];
//}

- (void) removeBlur{
    
//    _darkBlurView.hidden = YES;
}

- (void)setText:(NSString *)text{
    
    if (text != _text) {
        
        _text = text;
    }
    self.label.text = text;
}

/**
 *  @brief 当被复用时要重新计算子视图的 frame
 */
- (void)setItemFrame:(CGRect)itemFrame{
    
    [self initFrames];
    self.label.frame = _textFrame;
    self.timeLabel.frame = _timeFrame;
    self.darkBlurView.frame = self.bounds;
    self.darkBlurView.hidden = YES;
}

@end

