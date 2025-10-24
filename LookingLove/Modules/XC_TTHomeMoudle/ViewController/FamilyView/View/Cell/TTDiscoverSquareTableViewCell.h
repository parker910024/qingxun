//
//  TTDiscoverSquareTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamily.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDiscoverSquareTableViewCell : UITableViewCell

/** 配置我的家族*/
- (void)configTTDiscoverSquareTableViewCell:(XCFamily *)family;
/** 配置家族 客服 家族指南 家族广场*/
- (void)configDicoverSquareOrFamilyGuide:(NSDictionary *)modelDic;
@end

NS_ASSUME_NONNULL_END
