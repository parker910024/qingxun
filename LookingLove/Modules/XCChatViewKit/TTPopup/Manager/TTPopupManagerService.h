//
//  TTPopupManagerService.h
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPopupManagerServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPopupManagerService : NSObject<TTPopupManagerServiceProtocol>

/**
 当前显示的弹窗服务
 */
@property (nonatomic, strong) id<TTPopupServiceProtocol> currentPopupService;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
