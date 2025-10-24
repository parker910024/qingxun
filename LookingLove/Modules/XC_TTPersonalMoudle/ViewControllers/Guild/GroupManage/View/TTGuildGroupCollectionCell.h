//
//  TTGuildGroupCollectionCell.h
//  TuTu
//
//  Created by lvjunhang on 2019/1/9.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//  成员列表

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern CGFloat const TTGuildGroupCollectionCellTopMargin;//顶部边距
extern CGFloat const TTGuildGroupCollectionCellBottomMargin;//底部边距
extern CGFloat const TTGuildGroupCollectionCellCVHoriInterval;//cell水平间距
extern CGFloat const TTGuildGroupCollectionCellCVVertInterval;//cell垂直间距
extern CGFloat const TTGuildGroupCollectionCellLenth;//cell长度

@class TTHomeRecommendDetailData;

@interface TTGuildGroupCollectionCell : UITableViewCell
@property (nonatomic, strong) NSArray<NSString *> *dataModelArray;

@property (nonatomic, strong) UIView *separateLine;

@end

NS_ASSUME_NONNULL_END
