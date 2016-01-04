//
//  ViewController.m
//  WELFastTest
//
//  Created by WELCommand on 15/12/23.
//  Copyright © 2015年 WELCommand. All rights reserved.
//

#import "ViewController.h"
#import "WELFallDelegate.h"


@interface ViewController ()<UICollectionViewDelegate>

@property (nonatomic ,strong) WELFallDelegate *dataDelegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;


@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _datas = [NSMutableArray new];
    
    
    //////////  user like this
    _dataDelegate = [[WELFallDelegate alloc] initWithCollection:_collection cellCount:^NSInteger{
        return _datas.count;
    } configureCell:^UICollectionViewCell *(WELFallLoadCell loadCell, NSInteger index) {
        
        UICollectionViewCell *cell = loadCell(@"testCell");
        
        [cell setValue:_datas[index] forKeyPath:@"textLabel.text"];
        return cell;
    }];
    ////////////////
    
    
    [self loadingMoreData:nil];
    
}


- (IBAction)loadingMoreData:(id)sender {
    [self LoadData:^{
        [_collection reloadData];
    }];
}

- (IBAction)reloadingData:(id)sender {
    [_datas removeAllObjects];
    
    [self LoadData:^{
        [_collection wel_reloadDataAndDiscardLayout];
    }];
}




- (void)LoadData:(void (^)(void))success {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for(NSInteger i = 0; i < 100; i++) {
            NSInteger number = arc4random() % 5 + 1;
            
            NSString *temp = @"Xcode是一个标准Cocoa程序";
            NSMutableString *str = [[NSMutableString alloc] init];
            for (NSInteger j = 0; j < number; j++) {
                [str appendString:temp];
            }
            [_datas addObject:str];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    });
}




@end
