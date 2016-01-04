//
//  WELFallCache.h
//  Calendar
//
//  Created by WELCommand on 15/12/21.
//  Copyright © 2015年 Ole Begemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WELFallCache : NSObject

@property (nonatomic, strong) NSMutableDictionary *cellTemplates;


-(NSValue *)cellSizeWithIndex:(NSInteger)index;
-(void)cacheCellSize:(CGSize)size;


-(NSValue *)cellFrameWithIndex:(NSInteger)index;
-(void)cacheCellFrame:(CGRect)frame;

-(void)discardAllCache;


@end
