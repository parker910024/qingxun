//
//  TTFamilyMemberMonViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/21.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "XCFamilyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyMemberMonViewController : BaseTableViewController
/** 是不是搜索群流水的*/
@property (nonatomic, assign) BOOL isWeekRecord;
/** 群的id*/
@property (nonatomic, assign) NSInteger chatId;
/** 搜索的那个人*/
@property (nonatomic, strong) XCFamilyModel * searchModel;

@end

NS_ASSUME_NONNULL_END
