//
//  TTChatterboxGameModel.h
//  AFNetworking
//
//  Created by apple on 2019/6/3.
//

#import "BaseObject.h"

typedef enum : NSUInteger {
    TTChatterboxGameType_noll = 1,  // 双方没有操作
    TTChatterboxGameType_send = 2, // 自己点了抛点数
} TTChatterboxGameType;


NS_ASSUME_NONNULL_BEGIN

@interface TTChatterboxGameModel : BaseObject

@property (nonatomic, assign) int status; // 当前游戏状态
@property (nonatomic, assign) int pointCount; // 骰子点数
@property (nonatomic, strong) NSArray *listArray; // 游戏内容
@property (nonatomic, assign) UserID startTime; // 开始时间

/** 是不是展示过了*/
@property (nonatomic,assign) BOOL isShow;
@end

NS_ASSUME_NONNULL_END
