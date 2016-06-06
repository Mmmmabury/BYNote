//
//  BYCollectionFlowView.m
//  CoreText
//
//  Created by cby on 16/5/24.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "BYNCollectionFlowView.h"
#import "BYNCollectionFlowLayout.h"
#import "BYNCollectionCell.h"
#import "BYNCELLSIZE.h"

@interface BYNCollectionFlowView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, copy) NSArray *texts;
@property (nonatomic, copy) NSArray *colors;
@end

@implementation BYNCollectionFlowView


/**
 *  @brief 计算各个 item 的 frame
 */
- (void) calculateFrames{
    
    CGRect lastFrame = CGRectZero;
    // 计算 间距值
    CGFloat inset = (numberOfRow + 1) * itemInset;
    // 每个 cell 的宽
    CGFloat cellWidth = (SCREEN_WIDTH - inset) / numberOfRow;
    self.frames = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        
        [self.frames addObject:[[NSMutableArray alloc] init]];
    }
    
    // 计算frame
    for (int row = 0; row < numberOfRow; row++) {
        
        lastFrame = CGRectZero;
        for (int i = row; i < self.texts.count; i += numberOfRow) {
            
            NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:self.texts[i] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}];
            CGRect rect = [attriString boundingRectWithSize:CGSizeMake(cellWidth - 8, SCREEN_HEIGHT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            CGFloat height = ceil(rect.size.height);
            CGFloat cellY = lastFrame.origin.y + lastFrame.size.height + itemInset;
            CGFloat cellX = itemInset * (row + 1) + cellWidth * row;
            CGRect frame = CGRectMake(cellX, cellY, cellWidth, height + itemInset + timeLabelHeight);
            
            lastFrame = frame;
            
            [self.frames[row] addObject:[NSValue valueWithCGRect:frame]];
        }
    }
}


/**
 *  @brief 初始化
 *
 *  @param frame  view 的 frame 值
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    [self loadData];
    [self calculateFrames];
    BYNCollectionFlowLayout *flowLayout = [[BYNCollectionFlowLayout alloc] initWithItemFrames:[self.frames copy]];
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    
    if (self) {
        
        [self registerClass:[BYNCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        
        self.delegate = self;
        self.dataSource = self;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.5);
    }
    return self;
}

/**
 *  @brief 初始化数据
 */
- (void) loadData{
    
    self.texts = @[@"卡片理五 A 409\n李四117\n八格牙路\n填完",
                   @"buhaosdaifjaewiohfdkasjeroifdnsagij",
                   @"buhaosdaifjaewiohfdkasjeroifdnsagij",
                   @"buhaosdaifjaewiohfdkasjeroifdnsagij",
                   @"buhaosdaifjaewiohfdkasjeroifdnsagij",
                   @"buhaosdaifjaewiohfdkasjeroifdnsagij",
                   @"buhaosdaifjaewiohfdkasjeroifdnsagij",
                   @"buhaosdaifjaewiohfdkasjeroifdnsagij",
                   @"hehesdajfasihsnjcasdf",
                   @"ajeinfdadfdaksjjekgfas",
                   @"dsaiesjfakl;sdtfgajdlfk"];
    self.colors = @[[UIColor colorWithRed:0.0 green:0.5373 blue:0.9137 alpha:1.0],
                    [UIColor colorWithRed:0.1686 green:0.3098 blue:0.6078 alpha:1.0],
                    [UIColor colorWithRed:0.8353 green:0.2824 blue:0.1647 alpha:1.0],
                    [UIColor colorWithRed:0.0863 green:0.6314 blue:0.1059 alpha:1.0],
                    [UIColor colorWithRed:0.2588 green:0.698 blue:0.9373 alpha:1.0],
                    [UIColor colorWithRed:0.3294 green:0.1686 blue:0.698 alpha:1.0]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BYNCollectionCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSValue *value = self.frames[indexPath.item % 2][indexPath.item / 2];
    cell.text = self.texts[indexPath.item];
    cell.itemFrame = [value CGRectValue];
    cell.backgroundColor = self.colors[indexPath.item % 6];
//    cell.backgroundColor = [UIColor colorWithRed:0.2039 green:0.5098 blue:0.7922 alpha:1.0];
//    NSLog(@"%@", [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath]);
//    [cell applyLayoutAttributes:]
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.texts.count;
}

@end
