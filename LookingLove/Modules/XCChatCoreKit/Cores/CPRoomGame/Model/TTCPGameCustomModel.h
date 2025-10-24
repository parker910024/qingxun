//
//  TTCPGameCustomModel.h
//  TuTu
//
//  Created by new on 2019/1/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "TTCPGameCustomInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTCPGameCustomModel : BaseObject

@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) TTCPGameCustomInfo *gameInfo;
@property (nonatomic, strong) TTCPGameCustomInfo *gameResultInfo;
@property (nonatomic, strong) NSString *gameUrlString; // 仅当房间内匹配到外部用户。外部用户发云信自定义消息告诉房间内部游戏开始的时候使用。其他情况一律为空
@end

NS_ASSUME_NONNULL_END
