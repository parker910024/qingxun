//
//  LLDiscoverCharmTableViewCell.h
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/26.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamily.h"
NS_ASSUME_NONNULL_BEGIN

@interface LLDiscoverCharmTableViewCell : UITableViewCell

/** 配置我的家族*/
- (void)configTTDiscoverSquareTableViewCell:(XCFamily *)family;

/** 星推荐*/
- (void)configDiscoverCharmWith:(XCFamilyModel *)familyModel;
@end

NS_ASSUME_NONNULL_END
