//
//  TTMessageViewController.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/25.
//  Copyright © 2019 WJHD. All rights reserved.
//  消息控制器

#import "NIMSessionListViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageViewController : NIMSessionListViewController<JXCategoryListContentViewDelegate>

/** 是不是房间内消息
 */
@property (nonatomic, assign) BOOL isRoomMessage;
/** 控制器 因为房间内聊天没有控制器去push 或者做其他的操作*/
@property (nonatomic, weak) UIViewController * mainController;
@end

NS_ASSUME_NONNULL_END
