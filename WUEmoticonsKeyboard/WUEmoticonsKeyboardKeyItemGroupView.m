//
//  WUEmoticonsKeyboardKeyItemGroupView.m
//  WeicoUI
//
//  Created by YuAo on 1/25/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import "WUEmoticonsKeyboardKeyItemGroupView.h"
#import "WUEmoticonsKeyboardKeyCell.h"

CGFloat const WUEmoticonsKeyboardKeyItemGroupViewPageControlHeight = 23;

@interface WUEmoticonsKeyboardKeyItemGroupView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,weak)              UICollectionView             *collectionView;
@property (nonatomic,weak)              UIPageControl                *pageControl;
@property (nonatomic,weak)              WUEmoticonsKeyboardKeyCell   *lastPressedCell;
@property (nonatomic,weak)              UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic,weak,readwrite)    UIImageView        *backgroundImageView;
@end

@implementation WUEmoticonsKeyboardKeyItemGroupView

- (void)setKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup {
    _keyItemGroup = keyItemGroup;
    self.collectionView.collectionViewLayout = self.keyItemGroup.keyItemsLayout;
    [self.collectionView registerClass:self.keyItemGroup.keyItemCellClass forCellWithReuseIdentifier:NSStringFromClass(self.keyItemGroup.keyItemCellClass)];
    [self.collectionView reloadData];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:backgroundImageView];
        self.backgroundImageView = backgroundImageView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), WUEmoticonsKeyboardKeyItemGroupViewPageControlHeight)];
        pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, WUEmoticonsKeyboardKeyItemGroupViewPageControlHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - WUEmoticonsKeyboardKeyItemGroupViewPageControlHeight) collectionViewLayout:layout];
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewLongPress:)];
        longPressGestureRecognizer.minimumPressDuration = 0.08;
        [self.collectionView addGestureRecognizer:longPressGestureRecognizer];
        self.longPressGestureRecognizer = longPressGestureRecognizer;
    }
    return self;
}

#pragma mark - Long Press

- (void)collectionViewLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint touchedLocation = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *__block touchedIndexPath = [NSIndexPath indexPathForItem:NSNotFound inSection:NSNotFound];
    [self.collectionView.indexPathsForVisibleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = obj;
        if (CGRectContainsPoint([[self.collectionView layoutAttributesForItemAtIndexPath:indexPath] frame], touchedLocation)) {
            touchedIndexPath = indexPath;
            *stop = YES;
        }
    }];
    
    if (touchedIndexPath.item == NSNotFound || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.pressedKeyItemCellChangedBlock) {
            self.pressedKeyItemCellChangedBlock(self.lastPressedCell,nil);
        }
        [self.lastPressedCell setSelected:NO];
        self.lastPressedCell = nil;
        
        if (touchedIndexPath.item != NSNotFound) {
            WUEmoticonsKeyboardKeyItem *tappedKeyItem = self.keyItemGroup.keyItems[touchedIndexPath.item];
            if (self.keyItemTappedBlock) {
                self.keyItemTappedBlock(tappedKeyItem);
            }
        }
    }else{
        [self.lastPressedCell setSelected:NO];
        WUEmoticonsKeyboardKeyCell *pressedCell = (WUEmoticonsKeyboardKeyCell *)[self.collectionView cellForItemAtIndexPath:touchedIndexPath];
        [pressedCell setSelected:YES];
        
        if (self.pressedKeyItemCellChangedBlock) {
            self.pressedKeyItemCellChangedBlock(self.lastPressedCell,pressedCell);   
        }
        self.lastPressedCell = pressedCell;
    }
}


#pragma mark - CollectionView Delegate & DataSource

- (void)refreshPageControl {
    self.pageControl.numberOfPages = ceil(self.collectionView.contentSize.width / CGRectGetWidth(self.collectionView.bounds));
    self.pageControl.currentPage = floor(self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.bounds));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshPageControl];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshPageControl];
    });
    return self.keyItemGroup.keyItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WUEmoticonsKeyboardKeyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.keyItemGroup.keyItemCellClass) forIndexPath:indexPath];
    cell.keyItem = self.keyItemGroup.keyItems[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WUEmoticonsKeyboardKeyItem *tappedKeyItem = self.keyItemGroup.keyItems[indexPath.item];
    if (self.keyItemTappedBlock) {
        self.keyItemTappedBlock(tappedKeyItem);
    }
}

@end
