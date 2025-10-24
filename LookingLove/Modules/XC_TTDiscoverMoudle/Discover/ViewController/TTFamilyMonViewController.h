//
//  TTFamilyMonViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "XCFamilyMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyMonViewController : BaseTableViewController
@property (nonatomic, assign) FamilyMoneyOwnerType ownerType;//是自己 还是管理家族币
@property (nonatomic, assign) NSInteger chatId;//查询群流水
@property (nonatomic, assign) NSInteger tutuId;//查询家族
@end

NS_ASSUME_NONNULL_END
