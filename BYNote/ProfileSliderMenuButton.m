//
//  ProfileSliderMenuButton.m
//  BYNote
//
//  Created by cby on 16/6/6.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ProfileSliderMenuButton.h"

@interface ProfileSliderMenuButton ()

@property (nonatomic, copy) NSString *title;
@end
@implementation ProfileSliderMenuButton

- (instancetype)initWithFrame:(CGRect)frame andTitle: (NSString *) title{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.title = title;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    [[UIColor colorWithRed:0.2078 green:0.5137 blue:0.8 alpha:1.0] set];
    CGContextFillPath(context);
    
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius: rect.size.height/2];
    [roundedRectanglePath fill];
    [[UIColor whiteColor] setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSFontAttributeName:[UIFont systemFontOfSize:25.0f]};
    CGRect textRect = [_title boundingRectWithSize:CGSizeMake(200, 200)
                                         options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes context:nil];
    CGFloat differHeight = rect.size.height - textRect.size.height;
    
    [_title drawInRect:CGRectMake(rect.origin.x, rect.origin.y + differHeight / 2, rect.size.width, textRect.size.height) withAttributes: attributes];
}
@end
