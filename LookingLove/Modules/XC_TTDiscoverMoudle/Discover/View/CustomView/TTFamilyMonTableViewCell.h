//
//  TTFamilyMonTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamilyModel.h"
#import "XCFamilyMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyMonTableViewCell : UITableViewCell

- (void)configTTMonCellWithMonInfor:(XCFamilyModel *)family;

@property (nonatomic, assign) FamilyMoneyOwnerType type;
@property (nonatomic, weak) UIViewController * currentController;
@end

NS_ASSUME_NONNULL_END
