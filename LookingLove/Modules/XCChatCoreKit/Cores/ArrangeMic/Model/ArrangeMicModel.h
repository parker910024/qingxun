//
//  ArrangeMicModel.h
//  XCChatCoreKit
//
//  Created by gzlx on 2018/12/13.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "BaseObject.h"
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArrangeMicModel : BaseObject
/** 排麦的对列*/
@property (nonatomic, strong) NSArray<UserInfo *> *queue;
/** 参与排麦人数*/
@property (nonatomic, strong) NSString * count;
/** 我的排麦位置*/
@property (nonatomic, strong) NSString * myPos;

@end

NS_ASSUME_NONNULL_END
