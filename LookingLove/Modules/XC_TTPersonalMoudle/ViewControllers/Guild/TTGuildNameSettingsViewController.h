//
//  TTGuildNameSettingsViewController.h
//  TuTu
//
//  Created by lvjunhang on 2019/1/7.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//  设置厅名

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HallNameEditCompletion)(NSString *hallName);

@interface TTGuildNameSettingsViewController : BaseUIViewController

/**
 原来厅名
 */
@property (nonatomic, copy) NSString *hallName;

/**
 编辑完成回调
 */
@property (nonatomic, copy) HallNameEditCompletion editCompletion;

@end

NS_ASSUME_NONNULL_END
