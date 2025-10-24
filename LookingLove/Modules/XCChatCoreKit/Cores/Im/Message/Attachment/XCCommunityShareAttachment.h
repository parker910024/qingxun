//
//  XCCommunityShareAttachment.h
//  AFNetworking
//
//  Created by zoey on 2019/3/4.
//

#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCCommunityShareAttachment : Attachment
@property (nonatomic,strong) NSString                   *createTime;//显示标题
@property (nonatomic,strong) NSString                   *cover;//封面
@end

NS_ASSUME_NONNULL_END
