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

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface BYNCollectionFlowView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, copy) NSArray *texts;
@end

@implementation BYNCollectionFlowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    
    
}

- (void) calculateFrames{
    
    CGRect lastFrame = CGRectZero;
    CGFloat cellWidth = (SCREEN_WIDTH - 3 * 5) / 2;
    self.frames = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        
        [self.frames addObject:[[NSMutableArray alloc] init]];
    }
    
    // 第一列的 frame
    for (int row = 0; row < 2; row++) {
        
        lastFrame = CGRectZero;
        for (int i = row; i < self.texts.count; i += 2) {
            
            NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:self.texts[i] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0f]}];
            CGRect rect = [attriString boundingRectWithSize:CGSizeMake(cellWidth, SCREEN_HEIGHT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            CGFloat height = ceil(rect.size.height);
            CGFloat cellY = lastFrame.origin.y + lastFrame.size.height + 5;
            CGRect frame = CGRectMake(5 * (row + 1) + cellWidth * row, cellY, cellWidth, height);
            
            lastFrame = frame;
            
            [self.frames[row] addObject:[NSValue valueWithCGRect:frame]];
        }
    }
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    self.texts = @[@"nihadasegasdfodae\ndaefadfawe\ndaegdcadagewgaa\ndasrgagewa", @"buhaosdaifjaewiohfdkasjeroifdnsagij", @"hehe", @"ajeinfdadf", @"dsaiesjf"];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BYNCollectionCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    cell.text = self.texts[indexPath.item];
//    NSLog(@"%@", [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath]);
//    [cell applyLayoutAttributes:]
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.texts.count;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSLog(@"h");
    return attrs;
}
@end
