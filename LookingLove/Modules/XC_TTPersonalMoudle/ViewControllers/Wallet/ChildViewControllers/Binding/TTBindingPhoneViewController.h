//
//  TTBindingPhoneViewController.h
//  TuTu
//
//  Created by lee on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 手机号绑定的类型

 - TTBindingPhoneNumTypeUndefined: 未知状态, 没有主动传入类型
 - TTBindingPhoneNumTypeNormal: 普通状态，首次绑定
 - TTBindingPhoneNumTypeEdit: 编辑状态，已绑定过
 - TTBindingPhoneNumTypeConfirm : 验证状态：验证已绑定的手机
 */
typedef NS_ENUM(NSUInteger, TTBindingPhoneNumType) {
    TTBindingPhoneNumTypeUndefined = -1,
    TTBindingPhoneNumTypeNormal = 0,
    TTBindingPhoneNumTypeEdit = 1,
    TTBindingPhoneNumTypeConfirm = 2,
};

@class UserInfo;

@interface TTBindingPhoneViewController : BaseUIViewController

@property (nonatomic, assign) TTBindingPhoneNumType bindingPhoneNumType;

@property (nonatomic, strong) UserInfo *userInfo;
@end

NS_ASSUME_NONNULL_END
