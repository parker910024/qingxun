//
//  UICollectionView+MJRefreshAutoManager.h
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MJFooterRefreshState) {
    MJFooterRefreshStateNormal,
    MJFooterRefreshStateLoadMore,
    MJFooterRefreshStateNoMore
};

@interface UICollectionView (MJRefreshAutoManager)

//距离屏幕原点的距离
@property (nonatomic, assign) CGFloat screenOrigins;
//collectionView的高度
@property (nonatomic, assign) CGFloat collectionViewHeightOnScreens;

@property (nonatomic,assign)MJFooterRefreshState footRefreshState;

@end
