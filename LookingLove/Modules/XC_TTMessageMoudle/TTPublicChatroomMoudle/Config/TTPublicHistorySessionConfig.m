//
//  TTPublicHistorySessionConfig.m
//  TuTu
//
//  Created by 卫明 on 2018/11/13.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicHistorySessionConfig.h"



@interface TTPublicHistorySessionConfig ()
<
    TTPublicHistoryMessageDataProviderDelegate
>
@end

@implementation TTPublicHistorySessionConfig

- (instancetype)initWithSession:(NIMSession *)session{
    self = [super init];
    if (self) {
        NSInteger limit = 20;
        self.provider = [[TTPublicHistoryMessageDataProvider alloc] initWithSession:session limit:limit];
        self.provider.delegate = self;
    }
    return self;
}

#pragma mark - TTPublicHistoryMessageDataProviderDelegate

- (void)onProviderGetNoData {
    if ([self.delegate respondsToSelector:@selector(thereIsNoData)]) {
        [self.delegate thereIsNoData];
    }
}

- (void)onProvideGetData {
    if ([self.delegate respondsToSelector:@selector(thereIsData)]) {
        [self.delegate thereIsData];
    }
}

- (id<NIMKitMessageProvider>)messageDataProvider {
    return self.provider;
}

- (BOOL)disableInputView{
    return YES;
}

//云消息不支持音频轮播
- (BOOL)disableAutoPlayAudio
{
    return YES;
}

//云消息不显示已读
- (BOOL)shouldHandleReceipt{
    return NO;
}

- (BOOL)disableReceiveNewMessages
{
    return YES;
}

@end
