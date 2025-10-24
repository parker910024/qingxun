//
//  TTPublicChatRoomConfig.h
//  TuTu
//
//  Created by 卫明 on 2018/11/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTSessionConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicChatRoomConfig : TTSessionConfig

- (instancetype)initWithChatroom:(NSString *)roomId;

@end

NS_ASSUME_NONNULL_END
