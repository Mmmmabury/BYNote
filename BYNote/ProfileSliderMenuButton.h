//
//  ProfileSliderMenuButton.h
//  BYNote
//
//  Created by cby on 16/6/6.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SliderButtonNotActive,
    SliderButtonActive,
    SliderButtonNormal
}buttonStatus;

@interface ProfileSliderMenuButton : UIButton

@property (nonatomic, assign) NSInteger status;
- (instancetype)initWithFrame:(CGRect)frame andTitle: (NSString *) title;
@end
