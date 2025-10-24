//
//  ArrangeMicCoreClient.h
//  XCChatCoreKit
//
//  Created by gzlx on 2018/12/13.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArrangeMicModel.h"
#import "Attachment.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ArrangeMicCoreClient <NSObject>

@optional

//房间开启排麦/关闭排麦
- (void)roomeOpenOrCloseArrangeMicSuccess:(NSDictionary *)dic status:(int)stauts;
- (void)roomeOpenOrCloseArrangeMicFail:(NSString *)message status:(int)stauts;

//排麦/取消排麦
- (void)begainOrCancleArrangeMicSuccess:(NSDictionary *)dic status:(int)status;
- (void)begainOrCancleArrangeMicFail:(NSString *)message status:(int)stauts;



//排麦列表
- (void)getArrangeMicListSuccess:(ArrangeMicModel *)arrangeList status:(int)status;
- (void)getArrangeMicListFail:(NSString *)message status:(int)stauts;
//排麦列表的长度
- (void)getArrangeMicListSizeSuccess:(int)memberCount;
- (void)getArrangeMicListSizeFail:(NSString *)message;

- (void)roomArrangeMicStatusChangeWith:(CustomNotiHeaderArrangeMic)status;
//抱上麦的时候 是自己发的自定义消息 成功之后刷新
- (void)embracUserToMicSendMessageSuccess;


@end

NS_ASSUME_NONNULL_END
