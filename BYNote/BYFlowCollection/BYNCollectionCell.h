//
//  BYNCollectionCell.h
//  BYNote
//
//  Created by cby on 16/6/4.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYNCollectionCell : UICollectionViewCell

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) CGRect itemFrame;
@end
