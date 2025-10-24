//
//  LocationExpand.h
//  XCChatCoreKit
//
//  Created by lee on 2019/6/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"


NS_ASSUME_NONNULL_BEGIN

@interface LocationExpand : BaseObject

@property (nonatomic, copy) NSString *_id;
/** 用户ID */
@property (nonatomic, assign) UserID uid;
/** 经度 */
@property (nonatomic, assign) double longitude;
/** 纬度 */
@property (nonatomic, assign) double latitude;
/** 省区编码 */
@property (nonatomic, assign) NSInteger provinceCode;
/** 市区编码 */
@property (nonatomic, assign) NSInteger cityCode;
/** 省去名字 */
@property (nonatomic, copy) NSString *provinceName;
/** 市区名字 */
@property (nonatomic, copy) NSString *cityName;
/** 地址信息 */
@property (nonatomic, copy) NSString *address;
/** 更新时间 */
@property (nonatomic, assign) NSTimeInterval updateTime;
/** 是否展示个人信息 */
@property (nonatomic, assign) BOOL showLocation;

/** 是否展示年龄 */
@property (nonatomic, assign) BOOL showAge;
/** 是否匹配聊天 */
@property (nonatomic, assign) BOOL matchChat;

@end

NS_ASSUME_NONNULL_END
