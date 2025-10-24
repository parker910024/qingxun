//
//  TTFullinUserViewController.h
//  TuTu
//
//  Created by Macx on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

#import "UserCore.h"

@interface TTFullinUserViewController : BaseUIViewController
/**
 是否选择是男性
 */
@property (nonatomic, assign) BOOL isMan;
//用于判断是不是第三方登录
@property (strong, nonatomic) WeChatUserInfo *weChatInfo;
@property (strong, nonatomic) QQUserInfo *qqInfo;
@end
