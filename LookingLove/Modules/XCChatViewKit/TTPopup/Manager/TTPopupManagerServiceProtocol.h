//
//  TTPopupManagerServiceProtocol.h
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPopupServiceProtocol.h"

@protocol TTPopupManagerServiceProtocol <NSObject>

/**
 添加一个弹窗

 @param service 服从弹窗服务的实例
 */
- (void)addPopupService:(id<TTPopupServiceProtocol>)service;

/**
 移除一个弹窗
 */
- (void)removePopupService;

@end
