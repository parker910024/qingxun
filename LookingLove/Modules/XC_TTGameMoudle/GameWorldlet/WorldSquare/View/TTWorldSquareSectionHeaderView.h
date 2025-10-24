//
//  TTWorldSquareSectionHeaderView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  section 头

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldSquareSectionHeaderView : UICollectionReusableView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *actionButton;//箭头按钮

@property (nonatomic, copy) void (^moreActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
