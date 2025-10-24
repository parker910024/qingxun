//
//  BaseCollectionViewController.m
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "XCMacros.h"

@interface BaseCollectionViewController ()
@property (nonatomic, weak)UICollectionView * targetCollectionView;
@end

@implementation BaseCollectionViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark -- fresh
- (void)setupRefreshTarget:(UICollectionView *)collectionView
{
    //设置tableView默认 对象为lybaseviewcontroller的tableview
    if (collectionView==nil) collectionView = self.collectionView;
    
    self.targetCollectionView = collectionView;
    
    CGFloat targetCollectionOrigin = CGRectGetMinY(self.collectionView.frame);
    self.collectionView.screenOrigin = targetCollectionOrigin;
    self.collectionView.collectionViewHeightOnScreen = collectionView.collectionViewHeightOnScreen;
    @KWeakify(self);
    [collectionView setupRefreshFunctionWith:RefreshTypeHeaderAndFooter];
    
    [collectionView pullUpRefresh:^(int page, BOOL isLastPage) {
        @KStrongify(self);
        [self pullUpRefresh:page lastPage:isLastPage];
    }];
    
    [collectionView pullDownRefresh:^(int page)
     {
         @KStrongify(self);
         [self pullDownRefresh:page];
     }];
}

- (void)setupRefreshTarget:(UICollectionView *)collectionView with:(RefreshType)type
{
    //设置tableView默认 对象为lybaseviewcontroller的tableview
    if (collectionView==nil) collectionView = self.collectionView;
    
    self.targetCollectionView = collectionView;
    
    [collectionView setupRefreshFunctionWith:type];
    
    @KWeakify(self);
    
    if (type == RefreshTypeHeader)
    {
        [collectionView pullDownRefresh:^(int page) {
             @KStrongify(self);
             [self pullDownRefresh:page];
         }];
    }
    else if (type==RefreshTypeFooter)
    {
        [collectionView pullUpRefresh:^(int page, BOOL isLastPage) {
            @KStrongify(self);
            [self pullUpRefresh:page lastPage:isLastPage];
        }];
    }
    else
    {
        [self setupRefreshTarget:collectionView];
    }
}

- (void)pullDownRefresh:(int)page
{
    
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage
{
    
}

//请求成功结束刷新状态
- (void)successEndRefreshStatus:(int)status hasMoreData:(BOOL)hasMore
{
    [self.targetCollectionView endRefreshStatus:status hasMoreData:hasMore];
}

//请求成功结束刷新状态
- (void)successEndRefreshStatus:(int)status totalPage:(int)totalPage
{
    [self.targetCollectionView endRefreshStatus:status totalPage:totalPage];
}
//请求失败结束刷新状态
- (void)failEndRefreshStatus:(int)status
{
    [self.targetCollectionView endRefreshStatus:status];
}

#pragma mark - Getter & Setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.item
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

@end
