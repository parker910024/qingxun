//
//  DiscoveryCore.h
//  BberryCore
//
//  Created by Macx on 2018/3/5.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"

@interface DiscoveryCore : BaseCore

- (void)requestDiscoverAdListWithUid:(NSString *)uid;//请求发现列表


/**
 哈哈 上周礼物周星榜
 */
- (void)getLastWeekGiftListWith;

/*
 哈哈 发现页列表
 */
- (void)getDiscoverTypeList;

/**
 新秀玩友

 @param page 页数
 @param pageSize 一页几个
 @param status 头部还是尾部刷新
 */
- (void)getNewUserListWith:(int)page pageSize:(int)pageSize status:(int)status;

/** 是不是全部的显示全部的*/
- (void)getNewUserListWith:(int)page pageSize:(int)pageSize status:(int)status isTotal:(BOOL)isTotal;


/**
 萌声 萌新 新秀玩友
 
 @param page 页数
 @param pageSize 一页几个
 @param gender 性别，1-男性，2-女性，0-全部（不传时也查询所有)
 @param status 头部还是尾部刷新
 */
- (void)getNewUserListWith:(int)page pageSize:(int)pageSize gender:(int)gender status:(int)status;


#pragma mark -
#pragma mark 2019-03-29  公会线添加
/**
 获取发现页信息 v2
 interface discovery/v2/get
 */
- (void)requestDiscoverV2Info;
@end
