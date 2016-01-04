//
//  WELFallDelegate.h
//  Calendar
//
//  Created by WELCommand on 15/12/21.
//  Copyright © 2015年 Ole Begemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WELFallLayout.h"

typedef UICollectionViewCell* (^ WELFallLoadCell)(NSString *rid);
typedef UICollectionViewCell* (^ WELFallConfigureCell)(WELFallLoadCell loadCell, NSInteger index);
typedef NSInteger (^ WELFallCellCount)();


@interface WELFallDelegate : NSObject<UICollectionViewDataSource>

@property (nonatomic, readonly) WELFallCellCount cellCount;
@property (nonatomic, readonly) WELFallConfigureCell configure;


-(id)initWithCollection:(UICollectionView*)collection cellCount:(WELFallCellCount)count configureCell:(WELFallConfigureCell)configure;

@end



