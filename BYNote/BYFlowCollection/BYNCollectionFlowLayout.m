//
//  BYCollectionFlowLayout.m
//  CoreText
//
//  Created by cby on 16/5/24.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "BYNCollectionFlowLayout.h"
#import "BYNCELLSIZE.h"

@interface BYNCollectionFlowLayout ()

@property (assign, nonatomic) NSInteger itemsCount;
@end

@implementation BYNCollectionFlowLayout

- (instancetype) initWithItemFrames: (NSArray *) frames{
    
    self = [super init];
    if (self) {
        
        self.itemSize = CGSizeMake(100, 200);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.frames = frames;
    }
    return self;
}

- (void)prepareLayout{
    
    [super prepareLayout];
    _itemsCount = [[self collectionView] numberOfItemsInSection:0];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger index = indexPath.item;
    
    CGRect frame = [_frames[index % 2][index / 2] CGRectValue];
    
    attribute.frame = frame;
    return attribute;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _itemsCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributes addObject:attribute];
    }
//    NSArray *a = [super layoutAttributesForElementsInRect:rect];
//    NSLog(@"%@", a);
//    return [super layoutAttributesForElementsInRect:rect];
    return [attributes copy];
}

// contentSize
- (CGSize)collectionViewContentSize{
    
    CGFloat height = 0;
    CGFloat maxHeight = 0;
    NSInteger rowNum = 0;
    for (NSArray *row in self.frames) {
        
        for (NSValue *v in row) {
            
            CGRect rect = [v CGRectValue];
            height += rect.size.height;
        }
        if (height > maxHeight) {
            
            maxHeight = height;
            rowNum = row.count;
        }
        height = 0;
    }
    maxHeight += itemInset * (rowNum + 1) + 0;
    if (maxHeight < SCREEN_HEIGHT) {
        
        maxHeight = SCREEN_HEIGHT;
    }
    CGSize contentSize = CGSizeMake(SCREEN_WIDTH, maxHeight);
    return contentSize;
}
@end
