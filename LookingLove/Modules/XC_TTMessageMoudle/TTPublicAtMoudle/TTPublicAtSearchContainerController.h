//
//  TTPublicAtSearchController.h
//  TuTu
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"


//attachment
#import "PublicChatAtMemberAttachment.h"
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TTPublicAtSearchContainerControllerDelegate <NSObject>

/**
 选择完@的人

 @param members @的人 PublicChatAtMemberAttachment
 */
- (void)onAtUsersSelected:(PublicChatAtMemberAttachment *)members selectedDic:(NSMutableDictionary *)selectedDic;

@end

@interface TTPublicAtSearchContainerController : BaseUIViewController

/**
 delegate:TTPublicAtSearchContainerControllerDelegate
 */
@property (nonatomic,weak) id<TTPublicAtSearchContainerControllerDelegate> delegate;

/**
 选中的人
 */
@property (strong, nonatomic) NSMutableDictionary<NSString *,UserInfo *> *selectedUser;

- (void)show;

@end

NS_ASSUME_NONNULL_END
