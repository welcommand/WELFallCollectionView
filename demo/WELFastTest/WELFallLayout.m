//
//  WELFallLayout.m
//  Calendar
//
//  Created by WELCommand on 15/12/21.
//  Copyright © 2015年 Ole Begemann. All rights reserved.
//

#import "WELFallLayout.h"
#import "WELFallDelegate.h"
#import "WELFallCache.h"
#import <math.h>


struct WELContentLayoutP {
    CGFloat yr;
    CGFloat yl;
    CGFloat xr;
    CGFloat xl;
};
typedef struct WELContentLayoutP WELContentLayoutP;


@interface WELFallLayout () {
    NSInteger cellCount;
}

@property (nonatomic, weak) WELFallDelegate *collectionDataSource;

@property (nonatomic, strong) WELFallCache *cache;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) WELContentLayoutP layoutP;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation WELFallLayout


-(WELFallDelegate *)collectionDataSource {
    
    if(!_collectionDataSource) {
        NSAssert([[self.collectionView.dataSource class] isSubclassOfClass:[WELFallDelegate class]], @"The CollectionDataSource must be WELFallDelegate");
        _collectionDataSource = self.collectionView.dataSource;
    }
    
    return _collectionDataSource;
}


-(WELFallCache *)cache {
    if(!_cache) {
        _cache = [[WELFallCache alloc] init];
    }
    
    return _cache;
}

-(CGSize)contentSize {
    if(_contentSize.height == 0) {
        _contentSize = self.collectionView.frame.size;
    }
    
    return _contentSize;
}

//--

-(CGFloat)cellWidth {
    
    if(_cellWidth == 0) {
        _cellWidth =  (CGRectGetWidth(self.collectionView.frame) - self.left - self.right - self.horizontalToCellSpacing) / 2;
    }
    
    return _cellWidth;
}

-(WELContentLayoutP)layoutP {
    if(_layoutP.xl == _layoutP.xr) {
        _layoutP.yl = _layoutP.yr = self.top;
        _layoutP.xl = self.left;
        _layoutP.xr = self.left + self.horizontalToCellSpacing + self.cellWidth;
    }
    
    return _layoutP;
}



#pragma mark- Override method


-(CGSize)collectionViewContentSize {
    
    return self.contentSize;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    [self contextLayout];
    
    
    NSMutableArray *atts = [NSMutableArray new];
    
    for(NSInteger i = 0; i < self.collectionDataSource.cellCount(); i++) {
        CGRect cellFrame = [[self.cache cellFrameWithIndex:i] CGRectValue];
        if(CGRectIntersectsRect(rect,cellFrame)) {
            UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            att.frame = cellFrame;
            [atts addObject:att];
        }
    }
    
    return atts;
}


- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    att.frame = [[self.cache cellFrameWithIndex:indexPath.row] CGRectValue];
    return att;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}


#pragma mark- Help


-(void)discardLayout {
    self.cellWidth = 0;
    self.layoutP = (WELContentLayoutP){0,0,0,0};
    self.contentSize = (CGSize){0,0};
    cellCount = 0;
    [self.cache discardAllCache];
    [self.collectionView reloadData];
}


-(void)contextLayout {
    
    if(cellCount == self.collectionDataSource.cellCount()) return;
    
    for(NSInteger i = cellCount; i < self.collectionDataSource.cellCount(); i++) {
        
        CGFloat y,x;
        CGSize cellSize = [self sizeWithindex:i];
        
        if(self.layoutP.yl <= self.layoutP.yr) {
            y = self.layoutP.yl;
            x = self.layoutP.xl;
            _layoutP.yl += cellSize.height + self.verticalToCellSpacing;
        } else {
            y = self.layoutP.yr;
            x = self.layoutP.xr;
            _layoutP.yr += cellSize.height + self.verticalToCellSpacing;
        }
        
        [self.cache cacheCellFrame:(CGRect){x,y,cellSize}];
    }

    self.contentSize = (CGSize){self.contentSize.width, MAX(self.layoutP.yl, self.layoutP.yr) + self.bottom - self.verticalToCellSpacing};
    
    cellCount = self.collectionDataSource.cellCount();
    [self.collectionView reloadData];
    
}



-(CGSize)sizeWithindex:(NSInteger)index {
    
    NSValue *size = [self.cache cellSizeWithIndex:index];
    if(size) {
        return [size CGSizeValue];
    }
    
    WELFallLoadCell loadcell = ^(NSString *idstr) {
        
        UICollectionViewCell *cell = self.cache.cellTemplates[idstr];
        if(!cell) {
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:idstr forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [self addWidthConstraintWithCell:cell];
            
            self.cache.cellTemplates[idstr] = cell;
        }
        [cell prepareForReuse];
        
        return cell;
    };
    
    UICollectionViewCell *cell = self.collectionDataSource.configure(loadcell,index);

    CGSize cellSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    [self.cache cacheCellSize:cellSize];
    
    return cellSize;
}


-(void)addWidthConstraintWithCell:(UICollectionViewCell *)cell {
    if(cell.contentView.translatesAutoresizingMaskIntoConstraints) {
        cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.cellWidth];
        [cell.contentView addConstraint:widthConstraint];
    }
    
}


#pragma mark- collection dataDelegate


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WELFallLoadCell loadCell = ^(NSString *idstr) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idstr forIndexPath:indexPath];
        
        [self addWidthConstraintWithCell:cell];
        return cell;
    };
    
    return self.collectionDataSource.configure(loadCell,indexPath.row);
}

@end


@implementation UICollectionView (wel_reloadData)

-(void)wel_reloadDataAndDiscardLayout {
    WELFallLayout *layout = (WELFallLayout *)self.collectionViewLayout;
    
    if([layout respondsToSelector:@selector(discardLayout)]) {
        [layout discardLayout];
    }
}

@end
