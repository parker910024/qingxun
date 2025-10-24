//
//  TTMessageStrategy.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageStrategy.h"
#import "MessageBoardFilter.h"
#import "TTDisplayModelMaker+NonsupportMessage.h"

static TTMessageStrategy *instance;

@interface TTMessageStrategy ()

@property (nonatomic, strong) NSDictionary *Strategies;
@property (strong, nonatomic) NIMMessage *message;
@property (nonatomic, strong) TTMessageDisplayModel *model;
@property (nonatomic, strong) TTDisplayModelMaker *target;

@end

@implementation TTMessageStrategy

#pragma mark - puble method

+ (instancetype)defaultStrategy{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSInvocation *)strategyByMessageHeader:(CustomNotificationHeader)messageHeader target:(TTDisplayModelMaker *)target model:(TTMessageDisplayModel *)model message:(NIMMessage *)message{
    _model = model;
    _message = message;
    _target = target;
    
    // 该版本不支持此消息
    if (![MessageBoardFilter isSupportMsg:message]) {
        [target makeRoomNonsupportMessageContentWithMessage:message model:model];
        return nil;
    }
    
    NSString *key = [self strategiesKeyByMessageHeader:messageHeader];
    return self.Strategies[key];
}

#pragma mark - private method

- (NSInvocation *)invocationWithMethod:(NSString *)selectorString{
    
    NSMethodSignature*signature = [self.target.class instanceMethodSignatureForSelector:NSSelectorFromString(selectorString)];
    
    NSMethodSignature*signature1 = [self.target methodSignatureForSelector:NSSelectorFromString(selectorString)];
    
    if (signature == nil) {
        NSString *info = [NSString stringWithFormat:@"%@方法找不到", selectorString];
        [NSException raise:@"方法调用出现异常" format:info, nil];
    }
    
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setArgument:&self->_message atIndex:2];
    [invocation setArgument:&self->_model atIndex:3];
    invocation.target = self.target;
    invocation.selector = NSSelectorFromString(selectorString);
    return invocation;
}


- (NSString *)strategiesKeyByMessageHeader:(CustomNotificationHeader)messageHeader{
    
    return [NSString stringWithFormat:@"%d",messageHeader];
}

- (NSDictionary *)Strategies{
    
    NSDictionary *Strategies =
    @{@"3" : [self invocationWithMethod:@"makeGiftConentWithMessage:model:"],
      @"25" : [self invocationWithMethod:@"makeDragonContentWithMessage:model:"],
      @"16" : [self invocationWithMethod:@"makeRoomMagicContentWithMessage:model:"],
      @"2" : [self invocationWithMethod:@"makeRoomTipsContentWithMessage:model:"],
      @"12" : [self invocationWithMethod:@"makeRoomAllMicContentWithMessage:model:"],
      @"8" : [self invocationWithMethod:@"makeKickContentWithMessage:model:"],
      @"18" : [self invocationWithMethod:@"makeKickContentWithMessage:model:"],
      @"20" : [self invocationWithMethod:@"makeRoomUpdateRoomWithMessage:model:"],
      @"26" : [self invocationWithMethod:@"makeOpenBoxContentWithMessage:model:"],
      @"30" : [self invocationWithMethod:@"makeArrangeMicContentWithMessage:model:"],
      @"33" : [self invocationWithMethod:@"makeCPGameContentWith:model:"],
      @"35" : [self invocationWithMethod:@"makeRoomNormalGameWithMessage:model:"],
      @"41" : [self invocationWithMethod:@"makeCheckinDrawCoinContentWithMessage:model:"],
      @"46" : [self invocationWithMethod:@"makeLittleWorldWithMessage:model:"],
      @"50" : [self invocationWithMethod:@"makeSuperAdminWithMessage:model:"],
      @"56" : [self invocationWithMethod:@"makeEnterGreetingWithMessage:model:"],
      @"59" : [self invocationWithMethod:@"makeRedWithMessage:model:"],
      @"73" : [self invocationWithMethod:@"makeRoomLoveScreenMsgTipsWithMessage:model:"],
      };
    
    
    return Strategies;
}
@end
