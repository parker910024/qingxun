//
//  TTMemberListCell.h
//  TuTu
//
//  Created by lee on 2019/1/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kMemberListCellConst = @"kMemberListCellConst";

@class UserInfo;
@protocol TTMemberListCellDelegate <NSObject>

- (void)onCellSelectedClickHandler:(UIButton *)btn info:(UserInfo *)info;

@end

@interface TTMemberListCell : UITableViewCell

@property (nonatomic, strong) UserInfo *userInfo;
/** 是否是选中类型 */
@property (nonatomic, assign) BOOL isManagerSelected;
/** 是否是删除类型 */
@property (nonatomic, assign) BOOL isRemove;
/** 是否是普通类型 */
@property (nonatomic, assign) BOOL isNormal;
/** 多选类型 */
@property (nonatomic, assign) BOOL isMutable;
/** 禁言类型 */
@property (nonatomic, assign) BOOL isMute;
/** 是否是群聊 */
@property (nonatomic, assign) BOOL isGroup;
/** 当前操作人的身份 */
@property (nonatomic, copy) NSString *currentManagerRoleType;
@property (nonatomic, weak) id<TTMemberListCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
