//
//  TTPublicChatRoomConfig.m
//  TuTu
//
//  Created by 卫明 on 2018/11/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatRoomConfig.h"
#import "TTPublicChatroomMessageDataProvider.h"

@interface TTPublicChatRoomConfig ()

@property (strong, nonatomic) TTPublicChatroomMessageDataProvider *provider;

@end

@implementation TTPublicChatRoomConfig

- (instancetype)initWithChatroom:(NSString *)roomId {
    if (self = [super init]) {
        self.provider = [[TTPublicChatroomMessageDataProvider alloc]initWithChatroom:roomId];
    }
    return self;
}

- (id<NIMKitMessageProvider>)messageDataProvider{
    return self.provider;
}


@end
