//
//  TTFamilyEmptyTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyEmptyTableViewCell : UITableViewCell
/** 描述的问题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 空白的图片*/
@property (nonatomic, strong) UIImageView * iconImageView;

@end

NS_ASSUME_NONNULL_END
