//
//  TTSessionListViewController.h
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "NIMSessionListViewController.h"
#import "ZJScrollPageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTSessionListViewController : NIMSessionListViewController<ZJScrollPageViewChildVcDelegate>
/** 是不是房间内消息
 */
@property (nonatomic, assign) BOOL isRoomMessage;
/** 控制器 因为房间内聊天没有控制器去push 或者做其他的操作*/
@property (nonatomic, weak) UIViewController * mainController;
@end

NS_ASSUME_NONNULL_END
