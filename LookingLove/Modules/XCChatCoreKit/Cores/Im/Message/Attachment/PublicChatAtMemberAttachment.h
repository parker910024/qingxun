//
//  PublicChatAtMemberAttachment.h
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 KevinWang. All rights reserved.
//

#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublicChatAtMemberAttachment : Attachment<XCCustomAttachmentInfo>


/**
 被@的人的数组 such as:@["'@小明','"@小红'] 直接把@带上
 */
@property (strong, nonatomic) NSArray *atNames;

/**
 被@的人的uid 需要跟上面的名字对应位置
 */
@property (strong, nonatomic) NSArray *atUids;

/**
 文本内容
 */
@property (nonatomic,copy) NSString *content;

/**
 被@的人的名字，没有@的 不会发送到远端
 */
@property (strong, nonatomic,nullable) NSArray *originAtNames;

@end



NS_ASSUME_NONNULL_END
