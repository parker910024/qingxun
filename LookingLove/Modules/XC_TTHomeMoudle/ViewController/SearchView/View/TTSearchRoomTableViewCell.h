//
//  TTSearchRoomTableViewCell.h
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResultInfo;

typedef void(^PresentBtnClickBlcok)(UIButton *button);
@interface TTSearchRoomTableViewCell : UITableViewCell
/** 赠送按钮点击的block */
@property (nonatomic, strong) PresentBtnClickBlcok presentBtnClickBlcok;
/** 赠送按钮 */
@property (nonatomic, strong, readonly) UIButton *presentButton;
/** 邀请按钮 */
@property (nonatomic, strong, readonly) UIButton *inviteButton;

/// 进入房间按钮
@property (nonatomic, strong, readonly) UIButton *enterRoomButton;
/// 进入房间操作处理
@property (nonatomic, copy) void (^enterRoomHandler)(void);

@property (nonatomic, strong) SearchResultInfo *info;
@end
