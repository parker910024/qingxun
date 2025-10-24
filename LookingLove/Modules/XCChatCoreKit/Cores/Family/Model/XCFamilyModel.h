//
//  XCFamilyModel.h
//  BberryCore
//
//  Created by gzlx on 2018/6/4.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "LevelInfo.h"
//#import "UserInfo.h"

@interface XCFamilyModel : BaseObject

#pragma mark - 家族
/** 家族排行榜差距*/
@property (nonatomic, assign) double gapNumber;
/*
等级
 **/
@property (nonatomic, strong) NSString *   level;

/*
 贵族信息
 **/
@property (nonatomic, strong) NSString *  NobleInfo;

/*
 耳伴ID
 **/
@property (nonatomic, strong) NSString *   erbanNo;

#pragma mark - 群
/*
 群id
 **/
@property (nonatomic, strong) NSString *  tid;

/*
 群名称(群) / 成员的时候成员的名字
 **/
@property (nonatomic, strong) NSString *  name;

/*
 群头像
 **/
@property (nonatomic, strong) NSString *  icon;

/*
 是否在该群中
 **/
@property (nonatomic, strong) NSString *  status;

#pragma mark - 群成员
/*
 成员UId
 **/
@property (nonatomic, strong) NSString *  uid;
/*
 成员职位
 **/
@property (nonatomic, strong) NSString *  position;

#pragma mark - 游戏
/*
 游戏
 **/
@property (nonatomic, strong) NSString * id;

/*
 游戏的链接
 **/
@property (nonatomic, strong) NSString *  link;//链接的地址

#pragma mark - 家族币

/*
 家族币交易的时间
 **/
@property (nonatomic, strong) NSString *time;
/*
 家族币交易的金额
 **/
@property (nonatomic, assign) double amount;
/*
 家族币交易的标题
 **/
@property (nonatomic, strong) NSString *title;

/*
 家族币来源的类型
 **/
@property (nonatomic, strong) NSString * source;

/*
 家族币交易的头像
 **/
@property (nonatomic, strong) NSString * avatar;

/*
 @param nick 家族币交易的头像
 **/
@property (nonatomic, strong) NSString * nick;

/*
 1 链接 2 房间 3游戏 4装扮商城 当model为电话客服的时候 1 是在线 2 是电话
 **/
@property (nonatomic, strong) NSString *  type;

/*
 发现的bannner背景图
 **/
@property (nonatomic, strong) NSString *   pic;

/*
 跳转的类型
 **/
@property (nonatomic, strong) NSString *   param;


/*
 客服或者电话的时候内容
 **/
@property (nonatomic, strong) NSString *  content;

#pragma mark - 群
/**
 家族的id
 */
@property (nonatomic, strong) NSString *  familyId;

/**
     管理员数量
 */
@property (nonatomic, assign) int   managerCount ;

/**
   禁言数量
 */
@property (nonatomic, assign) int  disabledCount ;

/**
    成员数量
 */
@property (nonatomic, assign) int    memberCount ;

/**
   创建时间
 */
@property (nonatomic, strong) NSString *   createTime;

/**
     更新时间
 */
@property (nonatomic, strong) NSString *  updateTime ;

/**
 家族金豆
 */
@property (nonatomic, assign)  NSInteger  familyAccount;

/**
  是否需要验证
 */
@property (nonatomic, assign) BOOL isVerify;

/**
 是否在该群聊
 */
@property (nonatomic, assign) BOOL  isExists;

/**
 是不是选择了(自己添加的属性 防止在选择成员的时候出现 滑动的时候 以前选择的 会被覆盖)
 */
@property (nonatomic, assign) BOOL isSelect;

//家族魅力排行
@property (nonatomic, assign) BOOL openMoney;//是不是开启了家族币
@property (nonatomic, assign) BOOL openGame;//是不是开启了游戏
@property (nonatomic, assign) double familyCharm;//魅力值


//用户等级
@property(nonatomic, strong) LevelInfo *userLevelVo;
@property (nonatomic, assign) NSInteger gender;
@end

