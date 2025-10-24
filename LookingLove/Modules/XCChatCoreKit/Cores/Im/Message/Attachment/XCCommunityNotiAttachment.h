//
//  XCCommunityNotiAttachment.h
//  AFNetworking
//
//  Created by zoey on 2019/3/4.
//

#import "P2PInteractiveAttachment.h"

#import "XCCustomAttachmentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCCommunityNotiAttachment : P2PInteractiveAttachment<NIMCustomAttachment,XCCustomAttachmentInfo>
@property (nonatomic,strong) NSString                   *createTime;//显示标题
@property (nonatomic,strong) NSString                   *cover;//封面
@end

NS_ASSUME_NONNULL_END
