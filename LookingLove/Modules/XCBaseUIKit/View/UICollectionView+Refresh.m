//
//  UICollectionView+Refresh.m
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "UICollectionView+Refresh.h"
#import "RefreshFactory.h"
#import "UICollectionView+MJRefreshAutoManager.h"

@implementation UICollectionView (Refresh)

static void * kpage = (void *)@"currentPage";
static void * kheaderBlock = (void *)@"headerBlock";
static void * kfooterBlock = (void *)@"footerBlock";
static void * kloading = (void *)@"loading";
static void * ktotalPage = (void *)@"total";
static void * khasMore = (void *)@"hasMore";
static void * KscreenOrigin = (void *)@"screenOrigin";
static void * KcollectionViewHeightOnScreen = (void *)@"collectionViewHeightOnScreen";
#pragma mark -- Property
- (BOOL)isLoading
{
    return ((NSNumber*)objc_getAssociatedObject(self, kloading)).boolValue;
}

- (void)setIsLoading:(BOOL)isLoading
{
    objc_setAssociatedObject(self, kloading, @(isLoading), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hasMore
{
    return ((NSNumber*)objc_getAssociatedObject(self, khasMore)).boolValue;
}

- (void)setHasMore:(BOOL)hasMore
{
    objc_setAssociatedObject(self, khasMore, @(hasMore), OBJC_ASSOCIATION_ASSIGN);
}

- (int)currentPage
{
    return ((NSNumber*)objc_getAssociatedObject(self, kpage)).intValue;
}

- (void)setCurrentPage:(int)currentPage
{
    objc_setAssociatedObject(self, kpage, @(currentPage), OBJC_ASSOCIATION_ASSIGN);
}

- (int)totalPage
{
    return ((NSNumber*)objc_getAssociatedObject(self, ktotalPage)).intValue;
}

- (void)setTotalPage:(int)totalPage
{
    objc_setAssociatedObject(self, ktotalPage, @(totalPage), OBJC_ASSOCIATION_ASSIGN);
}
- (headerRefreshBlock)headerRefreshHandle
{
    return objc_getAssociatedObject(self, kheaderBlock);
}
- (void)setHeaderRefreshHandle:(headerRefreshBlock)headerRefreshHandle
{
    objc_setAssociatedObject(self, kheaderBlock, headerRefreshHandle, OBJC_ASSOCIATION_COPY);
}

- (footerRefreshBlock)footerRefreshHandle
{
    return objc_getAssociatedObject(self, kfooterBlock);
}

- (void)setFooterRefreshHandle:(footerRefreshBlock)footerRefreshHandle
{
    objc_setAssociatedObject(self, kfooterBlock, footerRefreshHandle, OBJC_ASSOCIATION_COPY);
}
- (CGFloat)screenOrigin
{
    return ((NSNumber*)objc_getAssociatedObject(self, KscreenOrigin)).floatValue;
}

- (void)setScreenOrigin:(CGFloat)screenOrigin
{
    objc_setAssociatedObject(self, KscreenOrigin, @(screenOrigin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)collectionViewHeightOnScreen{
    return ((NSNumber*)objc_getAssociatedObject(self, KcollectionViewHeightOnScreen)).floatValue;
}
- (void)setCollectionViewHeightOnScreen:(CGFloat)collectionViewHeightOnScreen{
    objc_setAssociatedObject(self, KcollectionViewHeightOnScreen, @(collectionViewHeightOnScreen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -- SEL
//set refresh
- (void)setupRefreshFunctionWith:(RefreshType)type
{
    self.currentPage = 1;//默认从1开始
    
    if (type == RefreshTypeHeader)
    {
        //集成头部刷新
        self.mj_header = [RefreshFactory headerRefreshWithTarget:self refreshingAction:@selector(headerRefresh)];
    }
    else if (type==RefreshTypeFooter)
    {
        //集成底部刷新
        self.mj_footer = [RefreshFactory footerRefreshWithTarget:self refreshingAction:@selector(footerRefresh)];
        self.mj_footer.automaticallyHidden = YES;//没有数据自动隐藏
        self.screenOrigins = self.screenOrigin;
        self.collectionViewHeightOnScreens = self.collectionViewHeightOnScreen;
        self.footRefreshState =MJFooterRefreshStateNormal;
    }
    else if (type == RefreshTypeHeaderAndFooter)
    {
        //集成底部刷新
        self.mj_footer = [RefreshFactory footerRefreshWithTarget:self refreshingAction:@selector(footerRefresh)];
        self.mj_footer.automaticallyHidden = YES;
        self.screenOrigins = self.screenOrigin;
        self.collectionViewHeightOnScreens = self.collectionViewHeightOnScreen;
        //集成头部刷新
        self.mj_header = [RefreshFactory headerRefreshWithTarget:self refreshingAction:@selector(headerRefresh)];
        self.footRefreshState =MJFooterRefreshStateNormal;
    }
    
}
//header
- (void)headerRefresh
{
    if (self.isLoading)
    {
        //如果是正在加载直接结束头部刷新动画
        [self endRefreshStatus:0];
        return;
    }
    
    self.currentPage = 1;//回复到默认值
    if (self.headerRefreshHandle)
    {
        self.headerRefreshHandle(self.currentPage);
        self.isLoading = YES;
    }
}
//footer
- (void)footerRefresh
{
    if (self.isLoading)
    {
        //如果是正在加载直接结束底部刷新动画
        [self endRefreshStatus:1];
        return;
    }
    
    NSLog(@"currentPage=%d----totalPage=%d",self.currentPage,self.totalPage);
    
    //没有更多数据
    if (!self.hasMore)
    {
        //调用刷新，且最后
        self.footerRefreshHandle(self.currentPage,YES);
        self.isLoading = NO;
        //结束刷新 提示没有更多数据
//        [self.mj_footer endRefreshingWithNoMoreData];
        self.footRefreshState =MJFooterRefreshStateNoMore;
        self.screenOrigins = self.screenOrigin;
        self.collectionViewHeightOnScreens = self.collectionViewHeightOnScreen;
        return;
    }
    //当前页数超过了或者等于最大页数
//    if (self.currentPage>=self.totalPage)
//    {
//        //调用刷新，且最后
//        self.footerRefreshHandle(self.currentPage,YES);
//        self.isLoading = NO;
//        //结束刷新 提示没有更多数据
//        [self.mj_footer endRefreshingWithNoMoreData];
//        return;
//    }
    
    self.currentPage++;
    
    if (self.footerRefreshHandle)
    {
        self.footerRefreshHandle(self.currentPage,NO);
        self.isLoading = YES;
    }
}
//up
- (void)pullUpRefresh:(footerRefreshBlock)block
{
    if (block)
    {
        self.footerRefreshHandle = block;
    }
}
//down
- (void)pullDownRefresh:(headerRefreshBlock)block
{
    if (block)
    {
        self.headerRefreshHandle = block;
    }
}

- (void)endRefreshStatus:(int)status totalPage:(int)totalPage
{
    self.totalPage = totalPage;
    
    self.isLoading = NO;
    
    [self endRefreshStatus:status];
}

- (void)endRefreshStatus:(int)status hasMoreData:(BOOL)hasMore
{
    self.hasMore = hasMore;
    
    self.isLoading = NO;
    
    [self endRefreshStatus:status];
}

- (void)endRefreshStatus:(int)status
{
    self.isLoading = NO;
    
    if (status==0)
    {
        [self.mj_header endRefreshing];
        [self.mj_footer resetNoMoreData];
    }
    else if (status==1)
    {
        [self.mj_footer endRefreshing];
    }
    
}

- (void)clearCurrentPage {
    self.currentPage = 1;
}

@end
