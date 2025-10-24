//
//  TTFamilyMemberViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FamilyCore.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TTFamilyMemberViewControllerDelegate <NSObject>

/** 选择完成之后*/
- (void)chooseFamilyMemberWith:(NSMutableDictionary *)memberDic;

@end

@interface TTFamilyMemberViewController : BaseTableViewController
@property (nonatomic, assign) FamilyMemberListType  listType;//类型
/** 查询家族中不在群里面的人*/
@property (nonatomic, assign) NSInteger teamId;

@property (nonatomic, assign) id<TTFamilyMemberViewControllerDelegate>delegate;
/** 选择过的人*/
@property (nonatomic, strong) NSMutableDictionary * selectDic;
/** 家族信息*/
@property (nonatomic, strong) XCFamily * familyInfor;
@end

NS_ASSUME_NONNULL_END
