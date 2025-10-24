//
//  TTDressupPresentViewController.h
//  TuTu
//
//  Created by zoey on 2018/11/23.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"


@class UserInfo;
@interface TTDressupPresentViewController : BaseUIViewController
@property (strong , nonatomic) void(^presentUserInfoBlock)(UserInfo *info);
@end
