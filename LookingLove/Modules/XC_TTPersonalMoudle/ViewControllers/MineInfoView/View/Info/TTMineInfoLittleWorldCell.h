//
//  TTMineInfoLittleWorldCell.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/22.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  Ta的小世界

#import <UIKit/UIKit.h>
#import "UserLittleWorld.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMineInfoLittleWorldCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataArray;//数据源

@property (nonatomic, copy) void (^selectedBlock)(UserLittleWorld *world);

/// 设置标题
- (void)setTitle:(NSString *)title;

@end

@interface TTMineInfoLittleWorldContentCell : UICollectionViewCell

/// 配置cell数据显示
- (void)configData:(UserLittleWorld *)data;

@end

NS_ASSUME_NONNULL_END
