//
//  WELFallCache.m
//  Calendar
//
//  Created by WELCommand on 15/12/21.
//  Copyright © 2015年 Ole Begemann. All rights reserved.
//

#import "WELFallCache.h"

@interface WELFallCache ()

@property (nonatomic, strong) NSMutableArray *sizeCache;

@property (nonatomic, strong) NSMutableArray *frameCache;

@end

@implementation WELFallCache


-(NSValue *)cellSizeWithIndex:(NSInteger)index {
    return (index < 0 || index >= self.sizeCache.count) ? nil : self.sizeCache[index];
}

-(void)cacheCellSize:(CGSize)size {
    [self.sizeCache addObject:[NSValue valueWithCGSize:size]];
}

-(NSValue *)cellFrameWithIndex:(NSInteger)index {
    return (index < 0 || index >= self.frameCache.count) ? nil : self.frameCache[index];
}

-(void)cacheCellFrame:(CGRect)frame {
    [self.frameCache addObject:[NSValue valueWithCGRect:frame]];
}

-(void)discardAllCache {
    [self.frameCache removeAllObjects];
    [self.sizeCache removeAllObjects];
}

#pragma mark- get/set

-(NSMutableArray *)frameCache {
    if(!_frameCache) {
        _frameCache = [NSMutableArray new];
    }
    return _frameCache;
}

-(NSMutableArray *)sizeCache {
    if(!_sizeCache) {
        _sizeCache = [NSMutableArray new];
    }
    return _sizeCache;
}

-(NSMutableDictionary *)cellTemplates {
    if(!_cellTemplates) {
        _cellTemplates = [NSMutableDictionary new];
    }
    
    return _cellTemplates;
}

@end
