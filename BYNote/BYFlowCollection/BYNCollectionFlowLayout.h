//
//  BYCollectionFlowLayout.h
//  CoreText
//
//  Created by cby on 16/5/24.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYNCollectionFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, copy) NSArray *frames;

- (instancetype) initWithItemFrames: (NSArray *) frames;

@end
