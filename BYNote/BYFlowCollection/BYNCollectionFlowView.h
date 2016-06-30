//
//  BYCollectionFlowView.h
//  CoreText
//
//  Created by cby on 16/5/24.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FLOWVIEW_UP_SCROLL_NOTI @"scrollup"
#define FLOWVIEW_DOWN_SCROLL_NOTI @"scrolldown"

@interface BYNCollectionFlowView : UICollectionView

@property (nonatomic, strong) NSArray *localNotes;
@end
