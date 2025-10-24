//
//  DynamicImage.h
//  XCChatCoreKit
//
//  Created by Lee on 2019/11/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN
//{
//    format = jpeg;
//    h = 1104;
//    hash = FoNkCXlKJPIQRi2MqLsVzfdSCO93;
//    key = FoNkCXlKJPIQRi2MqLsVzfdSCO93;
//    w = 828;
//}
@interface DynamicImage : BaseObject
// 图片key
@property (nonatomic, copy) NSString *key;
// 图片类型 gif, png, jpeg
@property (nonatomic, copy) NSString *format;
// hash
@property (nonatomic, copy) NSString *hashStr;
// 宽
@property (nonatomic, assign) CGFloat w;
// 高
@property (nonatomic, assign) CGFloat h;

@end

NS_ASSUME_NONNULL_END
