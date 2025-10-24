//
//  HttpRequestHelper+DiamondBox.h
//  XCChatCoreKit
//
//  Created by JarvisZeng on 2019/5/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "BoxKeyInfoModel.h"
#import "BoxPrizeModel.h"
#import "BoxConfigInfo.h"
#import "BoxCirtData.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (DiamondBox)
/*
 获取钻石钥匙数量与价格
 */
+ (void)requestDiamondBoxKeysInfoSuccess:(void (^)(BoxKeyInfoModel *keyInfo))success
                                 failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 购买钻石钥匙
 keysNum: 钥匙数
 */
+ (void)requestBuyDiamondBoxKeysByKey:(int)keyNum
                              success:(void (^)(NSDictionary *info))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 钻石宝箱开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 */
+ (void)requestOpenDiamondBoxByKey:(int)keyNum
                       sendMessage:(BOOL)sendMessage
                           success:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/*
 钻石宝箱本期奖池
 */
+ (void)requestDiamondBoxPrizesSuccess:(void (^)(NSArray<BoxPrizeModel *> *boxPrizes))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure;



@end

NS_ASSUME_NONNULL_END
