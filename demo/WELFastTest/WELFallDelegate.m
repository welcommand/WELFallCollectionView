//
//  WELFallDelegate.m
//  Calendar
//
//  Created by WELCommand on 15/12/21.
//  Copyright © 2015年 Ole Begemann. All rights reserved.
//

#import "WELFallDelegate.h"

@interface WELFallDelegate () {
    WELFallCellCount cellCountBlock;
    WELFallConfigureCell configureBlock;
}

@property (nonatomic, assign) UICollectionView *collection;

@end

@implementation WELFallDelegate

-(id)initWithCollection:(UICollectionView*)collection cellCount:(WELFallCellCount)count configureCell:(WELFallConfigureCell)configure {
    
    if(self = [super init]) {
        cellCountBlock = [count copy];
        configureBlock = [configure copy];
        collection.dataSource = self;
        _collection = collection;
    }
    
    return self;
}


-(WELFallCellCount)cellCount {
    return cellCountBlock;
}

-(WELFallConfigureCell)configure {
    return configureBlock;
}


#pragma mark- collection DataSource Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cellCountBlock();
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id <UICollectionViewDataSource> tager = (id)_collection.collectionViewLayout;
    return [tager collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
}


@end