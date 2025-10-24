//
//  TTPersonGameCollectionViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamilyModel.h"
#import "XCFamily.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTPersonGameCollectionViewCell : UICollectionViewCell
/** 给家族游戏赋值*/
- (void)configpPersonGanmeCellWithFamilyModel:(XCFamilyModel *)game;
/** 家族成员赋值*/
- (void)configpPersonMemberCellWithFamilyModel:(XCFamilyModel *)game;
@end

NS_ASSUME_NONNULL_END
