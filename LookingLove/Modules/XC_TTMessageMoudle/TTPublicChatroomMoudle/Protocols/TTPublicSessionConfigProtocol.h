//
//  TTPublicSessionConfigProtocol.h
//  TuTu
//
//  Created by 卫明 on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTPublicSessionConfigProtocol <NSObject>


/**
 输入框是否禁用 @ 功能

 @return BOOL
 */
- (BOOL)disableAt;


/**
 会话聊天背景更换接口

 @return 聊天背景的UIIMageView
 */
- (UIImage *)publicSessionBackgroundImage;


@end

NS_ASSUME_NONNULL_END
