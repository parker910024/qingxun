//
//  TTHeadlineCollectionViewCell.h
//  TuTu
//
//  Created by lvjunhang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  头条 collection cell

#import <UIKit/UIKit.h>

@class HomebaseModel;

typedef void(^HeadLineBlock)(HomebaseModel *model);

@interface TTHomeRecommendHeadlineCollectionCell : UICollectionViewCell

@property (nonatomic, copy) HeadLineBlock touchHeadLineBlock;
@property (nonatomic, strong) HomebaseModel *model;

@property (nonatomic, strong) NSArray *modelArray;
 
@end
