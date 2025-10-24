//
//  TTMyFamilyMoneyTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamily.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTMyFamilyMoneyTableViewCell : UITableViewCell

- (void)configTTMyFamilyMoneyTableViewCellWithFamilyModel:(XCFamily *)family;

@end

NS_ASSUME_NONNULL_END
