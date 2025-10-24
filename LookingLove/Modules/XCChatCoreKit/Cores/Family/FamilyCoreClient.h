//
//  FamilyCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCFamily.h"
#import "XCFamilyModel.h"
#import "UserInfo.h"
#import "MessageParams.h"


@protocol FamilyCoreClient <NSObject>

@optional
- (void)onUpdateMessageFromOriginAndLocalSuccess:(NIMMessage *)message;

//家族广场
- (void)getFinderFamilyMessageSuccess:(NSDictionary *)finderDic;
- (void)getFinderFamilyMessageFail:(NSString *)message;

//家族广场列表
- (void)getFamilySqureListSuccess:(NSDictionary *)squareDic;
- (void)getFamilySqureListFail:(NSString *)squareDic;
//获取所有的家族
- (void)getTotalFamilysListSuccessStatus:(int)status andList:(NSArray *)familyList;
- (void)getTotalFamilysListFailStatus:(int)status andMessage:(NSString *)message;
//魅力家族
- (void)getTolalCharmFamilyListSuccess:(int)status family:(XCFamily *)family;
- (void)getTolalCharmFamilyListFail:(int)staus andMessage:(NSString *)message;
//家族广场的列表  通过搜索的时候
- (void)searchFamilyListSuccess:(NSArray<XCFamily *> *)familyList;
- (void)searchFamilyListFail:(NSString *)message;

//退出家族
- (void)quitFamilySuccess:(NSDictionary *)successDic;
- (void)quitFamilyFail:(NSString *)message;

//加入家族
- (void)enterFamilySuccess:(NSDictionary *)successDic;
- (void)enterFamilyFail:(NSString *)message;

//踢出家族
- (void)kickoutFamilySuccess:(NSDictionary *)successDic;
- (void)kickoutFamilyFail:(NSString *)successDic;

//家族币管理
- (void)fetchFamilyManagerSuccess:(XCFamily *)moneyManaer;
- (void)fetchFamilyManagerFail:(NSString *)message ;
//家族币(个人)记录
- (void)fetchFamilyMoneyListSuccess:(NSMutableArray<XCFamilyMoneyModel *> *)recordlist status:(int)status isSearch:(BOOL)isSearch;
- (void)fetchFamilyMoneyListFail:(NSString *)message status:(int)status isSearch:(BOOL)isSearch;
//家族币(家族)记录
- (void)getFamilyMoneyRecordSuccess:(NSMutableArray<XCFamilyMoneyModel *> *)recordList status:(int)status;
- (void)getFamilyMoneyRecordFail:(NSString *)message status:(int)status;

//交易家族币(族长分陪)
- (void)exchangeFamilyMoneySuccess:(NSDictionary *)statusDic;
- (void)exchangeFamilyMoneyFail:(NSString *)message;

//成员贡献家族币 给族长
- (void)memberContributeFamilyMoneySuccess:(NSDictionary *)dic;
- (void)memberContributeFamilyMoneyFail:(NSString *)dic;

//邀请他人加入家族
- (void)inviteOtherUserToFamilySuccess:(NSDictionary *)stautsDic;
- (void)inviteOtherUserToFamilyFail:(NSString *)message;

//收到自定义消息
- (void)reciveFamilyCustomMessageWith:(MessageParams *)messageDic;
//收到自定义的消息 刷新家族币
- (void)reciveMeesageReloadFamilyMoney:(MessageParams *)message;

//接受家族邀请
- (void)acceptFamilyInviteSuccess:(NSDictionary *)statusDic;
- (void)acceptFamilyInviteFail:(NSString *)message;

//查询家族成员
- (void)demandFamilyMemberListSuccess:(XCFamily *)memberList status:(NSInteger)status;
- (void)demandFamilyMemberListFail:(NSString *)message status:(NSInteger)status;

//搜索家族成员（搜索的时候）
- (void)searchFamilyMemberListSuccess:(NSArray *)memberList;
- (void)searchFamilyMemberListFail:(NSString *)message;

//客服电话和id
- (void)getServiceAndPhoneSuccess:(NSDictionary *)dic;

//家族的信息
- (void)getfamilyInforSuccess:(XCFamily *)familyModel;
- (void)getfamilyInforFail:(NSString *)dic;

//修改家族信息
- (void)modifyFamilyInforMessageSuccess:(NSDictionary *)familyDic;
- (void)modifyFamilyInforMessageFail;

//查询家族游戏列表
- (void)getFamilyGameListSuccess:(NSArray<XCFamilyModel *> *)familyGames familyId:(NSInteger)familyId;
- (void)getFamilyGameListFailure:(NSString *)message;

//查询不在群中的家族成员的列表
- (void)fetchFamilyMemberNotInGroupSuccess:(XCFamily * )familyInfor andStatus:(int)status isSearch:(BOOL)isSearch;
- (void)fetchFamilyMemberNotInGroupFail:(NSString *)members andStatus:(int)status isSearch:(BOOL)isSearch;

//查询群聊的周交易流水
- (void)getGroupWeekFamilyMoneyRecordSuccess:(XCFamily *)infor status:(int)status isSearch:(BOOL)isSearch;
- (void)getGroupWeekFamilyMoneyRecordFail:(NSString *)message status:(int)status isSearch:(BOOL)isSearch;
#pragma mark - mengsheng
- (void)getMSDiscoverInforSuccess:(NSMutableDictionary *)discoverInfor;
- (void)getMSDiscoverInforFail;
//发现页 获取家族信息
- (void)getMSDiscoverFamilyInforSuccess:(XCFamily *)familyInfor;

#pragma mark - tutu
- (void)getTTDiscoverBannerSuccess:(NSDictionary *)familyInfor;
- (void)getTTDiscoverBannerFail:(NSString *)familyInfor;
@end
