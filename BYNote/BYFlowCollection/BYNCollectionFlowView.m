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
#import "EditNoteViewController.h"
#import "CoreDataManager.h"
#import "Note.h"
#import "ViewController.h"
#import <YYText.h>

@interface BYNCollectionFlowView()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat _offsetY;
}
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, copy) NSArray *texts;
@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, strong) BYNCollectionFlowLayout *flowLayout;

@end

@implementation BYNCollectionFlowView

# pragma mark 各种初始化
/**
 *  @brief 初始化
 *
 *  @param frame  view 的 frame 值
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    [self loadData];
    _flowLayout = [[BYNCollectionFlowLayout alloc] initWithItemFrames:[self.frames copy]];
    self = [super initWithFrame:frame collectionViewLayout:_flowLayout];
    [self superViewController];
    if (self) {
        
        [self registerClass:[BYNCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        self.delegate = self;
        self.dataSource = self;
        
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
//        self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 64);
    }
    return self;
}

- (void)reloadData{
    
//    _localNotes = nil;
    [self loadData];
    _flowLayout.frames = [_frames copy];
    [super reloadData];
}
/**
 *  @brief 初始化数据
 */
- (void) loadData{
    
    // 获取笔记
//    NSManagedObjectContext *context = [[CoreDataManager shareCoreDataManager] managedObjectContext];
//    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content like '*'", @""];
//    
//    fetch.predicate = predicate;
//     _localNotes = [context executeFetchRequest:fetch error:nil];
    
    
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
//    self.colors = @[[UIColor colorWithRed:0.0 green:0.5373 blue:0.9137 alpha:1.0],
//                    [UIColor colorWithRed:0.1686 green:0.3098 blue:0.6078 alpha:1.0],
//                    [UIColor colorWithRed:0.8353 green:0.2824 blue:0.1647 alpha:1.0],
//                    [UIColor colorWithRed:0.0863 green:0.6314 blue:0.1059 alpha:1.0],
//                    [UIColor colorWithRed:0.2588 green:0.698 blue:0.9373 alpha:1.0],
//                    [UIColor colorWithRed:0.3294 green:0.1686 blue:0.698 alpha:1.0]];
    self.colors = @[[UIColor colorWithRed:0.8672 green:0.8672 blue:0.8672 alpha:1.0]];
    [self calculateFrames];
}

# pragma mark datasource 代理实现
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BYNCollectionCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSValue *value = self.frames[indexPath.item % 2][indexPath.item / 2];
    cell.note = _localNotes[indexPath.item];
    cell.itemFrame = [value CGRectValue];
    cell.backgroundColor = self.colors[indexPath.item % self.colors.count];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _localNotes.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    EditNoteViewController *editNote = nil;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Edit" bundle:[NSBundle mainBundle]];
    editNote = [sb instantiateViewControllerWithIdentifier:@"editViewController"];
    editNote.note = _localNotes[indexPath.row];
    [[self superViewController] presentViewController:editNote animated:YES completion:nil];
}

# pragma mark 计算 frame
/**
 *  @brief 计算各个 item 的 frame
 */
- (void) calculateFrames{
    
    CGRect lastFrame = CGRectZero;
    // 计算 间距值
    CGFloat inset = (numberOfRow + 1) * itemInset;
    // 每个 cell 的宽
    CGFloat cellWidth = (SCREEN_WIDTH - inset) / numberOfRow;
    // cell 的范围
    CGSize cellFrameMax = CGSizeMake(cellWidth - 10, SCREEN_HEIGHT * 8);
    self.frames = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        
        [self.frames addObject:[[NSMutableArray alloc] init]];
    }
    
    // 计算frame
    for (int row = 0; row < numberOfRow; row++) {
        
        lastFrame = CGRectZero;
        for (int i = row; i < _localNotes.count; i += numberOfRow) {
            
            Note *note = _localNotes[i];
//            NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:note.content attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]}];
            // 根据字符串的特性计算每行高度
//            CGRect rect = [attriString boundingRectWithSize:CGSizeMake(cellWidth - 8, SCREEN_HEIGHT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
            NSAttributedString *ss = [[NSAttributedString alloc] initWithString:note.content attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Heiti SC" size:FONT_SIZE + 0.5f]}];
            // YYText
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize: cellFrameMax text:ss];
            CGRect rect = layout.textBoundingRect;
            
            
            CGFloat height = ceil(rect.size.height);
            CGFloat cellY = lastFrame.origin.y + lastFrame.size.height + itemInset;
            CGFloat cellX = itemInset * (row + 1) + cellWidth * row;
            CGRect frame = CGRectMake(cellX, cellY, cellWidth, height + itemInset + timeLabelHeight + 20);
            
            lastFrame = frame;
            
            [self.frames[row] addObject:[NSValue valueWithCGRect:frame]];
        }
    }
}

# pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _offsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
//    NSLog(@"%.2f", scrollView.contentOffset.y);
//    NSLog(@"%.2f", targetContentOffset->y);
    CGFloat y = scrollView.contentOffset.y;
    if (y > _offsetY) {

        NSLog(@"视图向上滑动");
        [[NSNotificationCenter defaultCenter] postNotificationName:FLOWVIEW_UP_SCROLL_NOTI object:nil];
    }else{
        
#ifdef DEBUG
        NSLog(@"视图向下滑动");
#endif
        [[NSNotificationCenter defaultCenter] postNotificationName:FLOWVIEW_DOWN_SCROLL_NOTI object:nil];
    }
}

- (ViewController *)superViewController{
 
    UIResponder *nextResponder = self.nextResponder;
    while (nextResponder && ![nextResponder isMemberOfClass:[ViewController class]]) {
        
        nextResponder = nextResponder.nextResponder;
    }
    return (ViewController *) nextResponder;
}

- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    
    NSManagedObjectContext *context = [[CoreDataManager shareCoreDataManager] managedObjectContext];
    for (NSIndexPath *indexPath in indexPaths) {
        
        Note *note = _localNotes[indexPath.item];
        [context deleteObject:note];
    }
    [[CoreDataManager shareCoreDataManager] saveContext];
}

@end
