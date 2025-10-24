//
//  TTMessageAttributedString.h
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseAttrbutedStringHandler.h"
#import "UserInfo.h"
#import "Attention.h"
#import "MessageBussiness.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageAttributedString : BaseAttrbutedStringHandler
/** 通过用户信息 q创建富文本*/
+ (NSMutableAttributedString *)createMessageNameWith:(UserInfo *)userInfo;
/** 通过attention 创建富文本*/
+ (NSMutableAttributedString *)createMessageNameWithAttention:(Attention *)attention;

+ (NSMutableAttributedString *)creatResultByMessageStatus:(Message_Bussiness_Status)messageStatus nick:(nullable NSString *)nick;

//创建原生勋章富文本
+ (NSMutableAttributedString *)creatOrignBadgeAttributedbyUserInfo:(SingleNobleInfo *)nobleInfo;
@end

NS_ASSUME_NONNULL_END
