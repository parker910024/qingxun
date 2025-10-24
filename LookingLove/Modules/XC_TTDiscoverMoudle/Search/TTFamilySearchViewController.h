//
//  TTFamilySearchViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SearchResultInfo.h"
#import "FamilyCore.h"
#import "GroupMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTFamilySearchType){
   TTFamilySearchType_Common = 1,          //普通搜索
   TTFamilySearchType_Share  = 2,          //分享搜索
    TTFamilySearchType_Family = 3,          //家族搜索（搜索的所有家族）
    TTFamilySearchType_Family_Member = 4,    //搜索家族成员
    TTFamilySearchType_Group = 5,     //搜索所有的群成员
    TTFamilySearchType_Family_NotInGroup = 6, //不在群里面的家族成员
};

@protocol TTFamilySearchViewControllerDelegate <NSObject>
@optional
/** 搜索兔兔内人*/
- (void)didSelectCellWith:(SearchResultInfo *)infor;
/** 点击了家族成员*/
- (void)didSelectFamilyMemberWith:(XCFamilyModel *)familyMember selectDic:(NSMutableDictionary *)selectDic;
/** 点击了群成员*/
- (void)didSelectGroupMemberWith:(GroupMemberModel *)groupMember selectDic:(NSMutableDictionary *)selectDic;

@end

@interface TTFamilySearchViewController : BaseTableViewController

@property (nonatomic, strong) UINavigationController * currentNav;

@property (nonatomic, assign) TTFamilySearchType searchType;
/** 查询群聊成员的时候显示*/
@property (nonatomic, assign) NSInteger teamId;
/** 已经选择过的*/
@property (nonatomic, strong) NSMutableDictionary * selectMemDic;
/** 可以判断搜索时候需要做什么操作*/
@property (nonatomic, assign)FamilyMemberListType listType;

@property (nonatomic, assign) id<TTFamilySearchViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
