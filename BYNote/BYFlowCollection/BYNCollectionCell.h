//
//  BYNCollectionCell.h
//  BYNote
//
//  Created by cby on 16/6/4.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface BYNCollectionCell : UICollectionViewCell

@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) CGRect itemFrame;
@property (nonatomic, strong) Note *note;
@end
