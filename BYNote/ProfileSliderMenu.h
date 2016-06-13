//
//  ProfileSilderMenu.h
//  BYNote
//
//  Created by cby on 16/6/6.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderButtonAction <NSObject>

- (void)linkToEverNote;
@end

@interface ProfileSliderMenu : UIView

@property (nonatomic, strong) id<SliderButtonAction> delegate;

- (void) triggle;
@end
