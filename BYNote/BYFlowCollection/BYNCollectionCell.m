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
#import "BYNCollectionFlowView.h"

@interface BYNCollectionCell ()

//@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) BYTextView *textView;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) CGRect timeFrame;
@property (nonatomic, assign) CGRect textFrame;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIButton *optionView;
@end
@implementation BYNCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _image = nil;
        self.backgroundColor = [UIColor clearColor];
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
    
    _topView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_topView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:_timeFrame];
    _timeLabel.text = @"06-01 10:10";
    _timeLabel.font = [UIFont fontWithName:@"Heiti SC" size:10.0f];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.alpha = 0.8;
    //        timeLabel.backgroundColor = [UIColor colorWithRed:0.1961 green:0.3176 blue:0.4353 alpha:1.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:0.2507 green:0.247 blue:0.2544 alpha:0.8];
    [_topView addSubview:_timeLabel];
    
    // 功能视图
    _optionView = [[UIButton alloc] initWithFrame:self.contentView.bounds];
    [_optionView addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
    [_optionView setTitle:@"删除" forState:UIControlStateNormal];
    _optionView.width /= 3;
    _optionView.left = self.contentView.right - _optionView.width;
    _optionView.backgroundColor = [UIColor redColor];
    [self.contentView insertSubview:_optionView belowSubview:_topView];
    
    UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showOptionalButton:)];
    gr.maximumNumberOfTouches = 1;
    gr.minimumNumberOfTouches = 1;
    [self.contentView addGestureRecognizer:gr];
}

// 删除 cell
- (void)deleteCell{
    
    NSIndexPath *indexPath = [[self collectionView] indexPathForCell:self];
    [[self collectionView] deleteItemsAtIndexPaths:@[indexPath]];
    self.topView.transform = CGAffineTransformIdentity;
}

// 显示可选的按钮
- (void)showOptionalButton: (UIPanGestureRecognizer *) gr{
    
    if (gr.state != UIGestureRecognizerStateBegan) {
        
        return;
    }
    CGPoint location = [gr translationInView:self.contentView];
    NSLog(@"%@", NSStringFromCGPoint(location));
    CGFloat x = location.x;
    if (x < 0){
        
        [UIView animateWithDuration:0.2f animations:^{
           
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-_optionView.width, 0);
            _topView.transform = transform;
        }];
    }
    if (x > 0) {
        
        [UIView animateWithDuration:0.2f animations:^{
            
            _topView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)setNote:(Note *)note{
    
    _note = note;
    self.textView.note = note;
    NSDate *createDate = _note.create_date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    _timeLabel.text = [formatter stringFromDate:createDate];
}

- (BYTextView *)textView{
    
    if (!_textView) {
        
        _textView = [[BYTextView alloc] initWithNote:nil andFrame:_textFrame];
        _textView.editable = NO;
        _textView.userInteractionEnabled = NO;
        [_topView addSubview:_textView];
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
    self.topView.frame = self.bounds;
    self.optionView.height = self.height;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
    _topView.backgroundColor = backgroundColor;
}

- (BYNCollectionFlowView *)collectionView{
    
    UIResponder *nextResponder = self.nextResponder;
    while (![nextResponder isMemberOfClass:[BYNCollectionFlowView class]]) {
        
        nextResponder = nextResponder.nextResponder;
    }
    return (BYNCollectionFlowView *)nextResponder;
}
@end

