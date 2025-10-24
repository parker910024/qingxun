//
//  TTBindingXCZViewController.h
//  TuTu
//
//  Created by lee on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN


/**
 兔兔绑定用户提现账号信息类型

 - TTBindXCZAccountTypeNormal: 普通状态：第一次绑定
 - TTBindXCZAccountTypeEdit: 编辑状态：已绑定，进行编辑
 */
typedef NS_ENUM(NSUInteger, TTBindXCZAccountType) {
    /** 普通状态：第一次绑定 */
    TTBindXCZAccountTypeNormal = 0,
    /** 编辑状态：已绑定，进行编辑*/
    TTBindXCZAccountTypeEdit = 1,
};

@class UserInfo, ZXCInfo;
@interface TTBindingXCZViewController : BaseUIViewController
/** 用户信息 */
@property (nonatomic, strong) UserInfo *userInfo;
/** 提现账号信息 */
@property (nonatomic, strong) ZXCInfo *zxcInfo;
@property (nonatomic, assign) TTBindXCZAccountType bindXCZAccountType;
@end

NS_ASSUME_NONNULL_END
