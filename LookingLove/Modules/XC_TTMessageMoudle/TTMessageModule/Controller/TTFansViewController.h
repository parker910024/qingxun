//
//  TTFansViewController.h
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ZJScrollPageView.h"
#import "UserInfo.h"
#import "TTMessageContentViewController.h"
#import "TTSendPresentUserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TTFansViewControllerDelegate <NSObject>

/** 吧选择的人 传出去*/
- (void)chooseFansInforWith:(NSDictionary*)userInforDic;

@end

typedef void(^SelectPresentBlock)(TTSendPresentUserInfo *user);

@interface TTFansViewController : BaseTableViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic, assign) BOOL isReload;

/** 选择过的人*/
@property (nonatomic, strong) NSMutableDictionary * selectDic;
/** 是不是选择的 如果不是不需要遵循此代理*/
@property (nonatomic, assign)id<TTFansViewControllerDelegate> delegate;

/** 选择赠送人的回调，实现此 block 后会为 cell 绘制一个“赠送”按钮 */
@property (nonatomic, copy) SelectPresentBlock selectPresentBlock;

/** 是不是房间内消息
 */

@property (nonatomic, assign) MessageVCType type;
/** 控制器 因为房间内聊天没有控制器去push 或者做其他的操作*/
@property (nonatomic, weak) UIViewController * mainController;

@end

NS_ASSUME_NONNULL_END
