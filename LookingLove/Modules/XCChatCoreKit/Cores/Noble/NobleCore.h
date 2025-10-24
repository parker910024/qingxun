//
//  PeeragesCore.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "NobleInfo.h"
#import "SingleNobleInfo.h"

#import "HttpRequestHelper+Noble.h"

@interface NobleCore : BaseCore

@property (nonatomic, assign) NSInteger version; //特权资源版本

@property (nonatomic, copy) NSString *zipUrl;// zipurl

@property (nonatomic, copy) NSString *destinationUrl;

@property (nonatomic, strong)NSMutableDictionary *sources;
@property (nonatomic, strong)NSMutableDictionary<NSString *, NobleInfo *> *privilegeDict;
@property (nonatomic, strong)NSMutableDictionary<NSString *, NobleInfo *> *tempPrivilegeDict;


/**
 清除贵族的内存缓存（收到内存警告的时候使用）
 */
- (void)cleanNobleMemoryCache;

/**
 查询贵族特权

 @param uid 要查询的UID
 @return rac信号 对象是:NobleInfo
 */
- (RACSignal *)queryPrivilege:(UserID)uid;

/**
 查询图片资源

 @param uid 需要查询的uid
 @param type 数组：需要查询的数据的枚举 NSNumber
 @return rac信号 对象是:NSDictionary
 */
- (RACSignal *)singleNobleInfoBy:(UserID)uid type:(NSArray *)type;


/**
 查询图片资源（同步）

 @param info EXT里面的SingleNobleInfo
 @param type 数组：需要查询的数据的枚举 NSNumber
 @return rac信号 对象是:NSDictionary
 */
- (NSMutableDictionary<NSNumber *,NobleSourceInfo *> *)singleNobleInfoByUserNoble:(SingleNobleInfo *)info type:(NSArray *)type;

/**
 通过图片名去查id

 @param sourceId 资源名
 @return UIImage
 */
- (UIImage *)findNobleSourceBySourceId:(NSString *)sourceId;


/**
 皇帝推荐url
 @return 皇帝推荐url
 */
- (id)findRecommondUrl;

/*
 查询房间贵族列表
 roomUid:房主uid
 */
- (void)requestRoomNobleUserList:(NSString *)roomUid;


/*
 请求购买贵族订单
 nobleId:      贵族的id
 productId:   内购id
 nobleOptType: 1购买。 2续费
 */
- (void)requestNobleOrderByProductId:(NSString *)productId nobleId:(NSNumber *)nobleId nobleOptType:(OrderNobleType)nobleOptType;

@end
