//
//  TTPopupService.h
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPopupServiceProtocol.h"

// TTPopupConfig 是 TTPopupService 的别称
// 具体信息见 TTPopupService
#define TTPopupConfig TTPopupService

NS_ASSUME_NONNULL_BEGIN

@interface TTPopupService : NSObject<TTPopupServiceProtocol>

@end

NS_ASSUME_NONNULL_END
