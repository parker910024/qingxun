//
//  TTGameStaticTypeCore.m
//  XCChatCoreKit
//
//  Created by new on 2019/3/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameStaticTypeCore.h"
#import "TTCPGameStaticCore.h"

@interface TTGameStaticTypeCore (){
    dispatch_source_t gameTimer;
}
@property (nonatomic, assign) NSInteger timerNumber; // 私聊发起游戏的计时器
@end

@implementation TTGameStaticTypeCore

- (instancetype)init{
    if (self = [super init]) {
        
        self.privateMessageArray = [NSMutableArray array];
        self.checkType = NO;
        self.selectGameForMe = NO;
        
    }
    return self;
}

- (void)createrTimer{
    if (!gameTimer) {
        self.timerNumber = GetCore(TTCPGameStaticCore).gameFrequency;
        
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        gameTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
        
        dispatch_source_set_timer(gameTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        
        @weakify(self);
        dispatch_source_set_event_handler(gameTimer, ^{
            @strongify(self);
            //1. 每调用一次 时间-1s
            self.timerNumber --;
            //2.对timeout进行判断时间是停止倒计时，
            if (self.timerNumber <= 0) {
                //关闭定时器
                dispatch_source_cancel(gameTimer);
                gameTimer = nil;
                self.launchGameSwitch = NO;
            }else {
                self.launchGameSwitch = YES;
            }
        });
        dispatch_resume(gameTimer);
    }
}

- (void)destructionTimer{
    if (gameTimer) {
        dispatch_source_cancel(gameTimer);
        gameTimer = nil;
    }
    self.launchGameSwitch = NO;
}


@end
