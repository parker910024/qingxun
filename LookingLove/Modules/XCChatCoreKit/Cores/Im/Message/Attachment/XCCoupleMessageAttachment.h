//
//  XCCustomAttachmentInfo.h
//  AFNetworking
//
//  Created by apple on 2018/12/6.
//

#import "Attachment.h"

#import <NIMSDK/NIMSDK.h>
#import "XCCustomAttachmentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCCoupleMessageAttachment : Attachment<NIMCustomAttachment,XCCustomAttachmentInfo>

@property (nonatomic,copy) NSString * from;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,assign) NSInteger roomId;
@property (nonatomic,assign) UserID coupleUid;
@end

NS_ASSUME_NONNULL_END
