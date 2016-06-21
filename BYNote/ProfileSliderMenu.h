//
//  ProfileSilderMenu.h
//  BYNote
//
//  Created by cby on 16/6/6.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileSliderMenuButton.h"

@protocol SliderButtonAction <NSObject>

- (void)linkToEverNote: (ProfileSliderMenuButton *) sender;
- (void)sendEmailAction;
- (void)displaySearchView;
- (void)authenticationWithFinger: (ProfileSliderMenuButton *) sender;
@end

@interface ProfileSliderMenu : UIView

@property (nonatomic, weak) id<SliderButtonAction> delegate;

- (void) triggle;
@end
