//
//  WELFallLayout.h
//  Calendar
//
//  Created by WELCommand on 15/12/21.
//  Copyright © 2015年 Ole Begemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WELFallLayout : UICollectionViewLayout


@property (nonatomic, assign) IBInspectable NSInteger top;
@property (nonatomic, assign) IBInspectable NSInteger bottom;
@property (nonatomic, assign) IBInspectable NSInteger right;
@property (nonatomic, assign) IBInspectable NSInteger left;

@property (nonatomic, assign) IBInspectable NSInteger horizontalToCellSpacing;
@property (nonatomic, assign) IBInspectable NSInteger verticalToCellSpacing;

@end


@interface UICollectionView (wel_reloadData)

-(void)wel_reloadDataAndDiscardLayout;

@end

