//
//  XCATAttachment.h
//  AFNetworking
//
//  Created by 卫明 on 2018/11/2.
//

#import "Attachment.h"

//router
#import "P2PInteractiveAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCATAttachment : Attachment

/**
 是在哪进行@的，如果id跟公聊大厅是一样的就证明
 */
@property (nonatomic,copy) NSString *roomId;

/**
 是@谁的
 */
@property (nonatomic,copy) NSString *atUid;

/**
 @人的名字
 */
@property (nonatomic,copy) NSString *atName;

/**
 转跳协议
 */
@property (nonatomic,assign) P2PInteractive_SkipType routerType;

/**
 转跳参数
 */
@property (nonatomic,copy) NSString *routerValue;

/**
 内容
 */
@property (nonatomic,copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
