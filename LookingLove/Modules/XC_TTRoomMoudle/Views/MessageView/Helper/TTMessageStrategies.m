//
//  TTMessageStrategies.m
//  TuTu
//
//  Created by KevinWang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageStrategies.h"

static TTMessageStrategies *instance;

@interface TTMessageStrategies()

@property (nonatomic, strong) NSDictionary *Strategies;
@property (strong, nonatomic) TTMessageDisplayModel *model;
@property (nonatomic, strong) TTMessageTextCell *cell;
@property (nonatomic, strong) TTMessageView *target;

@end

@implementation TTMessageStrategies

#pragma mark - puble method

+ (instancetype)defaultStrategy{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSInvocation *)strategyByMessageHeader:(CustomNotificationHeader)messageHeader target:(TTMessageView *)target cell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model{
    _cell = cell;
    _model = model;
    _target = target;
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
    [invocation setArgument:&self->_cell atIndex:2];
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
    @{@"-1" : [self invocationWithMethod:@"handleNonsupportMessageCell:model:"],
      @"3" : [self invocationWithMethod:@"handleGiftCell:model:"],
      @"25" : [self invocationWithMethod:@"handleDragonCell:model:"],
      @"16" : [self invocationWithMethod:@"handleRoomMagicCell:model:"],
      @"2" : [self invocationWithMethod:@"handleRoomTipCell:model:"],
      @"12" : [self invocationWithMethod:@"handleWholeMicSendCell:model:"],
      @"8" : [self invocationWithMethod:@"handleKickCell:model:"],
      @"18" : [self invocationWithMethod:@"handleKickCell:model:"],
      @"20" : [self invocationWithMethod:@"handleUpdateRoomInfo:model:"],
      @"26" : [self invocationWithMethod:@"handleOpenBox:model:"],
      @"30" : [self invocationWithMethod:@"handleArrangeMicCell:model:"],
      @"33" : [self invocationWithMethod:@"handleCPGameCell:model:"],
      @"35" : [self invocationWithMethod:@"handleNormalGameModelCell:model:"],
      @"41" : [self invocationWithMethod:@"messageCell:handleDrawCoinWithModel:"],
      @"46" : [self invocationWithMethod:@"handleLittleWorld:model:"],
      @"50" : [self invocationWithMethod:@"handleSuperAdminCell:model:"],
      @"56" : [self invocationWithMethod:@"handleEnterGreetingCell:model:"],
      @"59" : [self invocationWithMethod:@"handleRedCell:model:"],
      @"73" : [self invocationWithMethod:@"handleRoomLoveScreenCell:model:"],
      };
    
    return Strategies;
}

@end
