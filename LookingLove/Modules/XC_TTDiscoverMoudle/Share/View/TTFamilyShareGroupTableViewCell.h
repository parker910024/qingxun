//
//  TTFamilyShareGroupTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/19.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyShareGroupTableViewCell : UITableViewCell

- (void)configShareGroupCellWith:(GroupModel *)group;

@end

NS_ASSUME_NONNULL_END
