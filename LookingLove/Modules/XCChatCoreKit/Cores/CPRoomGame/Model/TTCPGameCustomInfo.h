//
//  TTCPGameCustomInfo.h
//  TuTu
//
//  Created by new on 2019/1/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTCPGameCustomInfo : BaseObject
// 游戏信息
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) UserID uid;
@property (nonatomic, strong) NSString *startUid;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *gameChannel;
@property (nonatomic, strong) NSString *gameIcon;
@property (nonatomic, strong) NSString *gamePicture;

//  游戏返回的结果
@property (nonatomic, strong) NSString *resultType;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *winners;
@property (nonatomic, strong) NSArray *failers;
@property (nonatomic, assign) UserID userCount;
@property (nonatomic, assign) UserID playerCount;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, assign) UserID watcherCount;
@property (nonatomic, assign) UserID roomId;
@property (nonatomic, strong) NSString *pkType;
@property (nonatomic, assign) UserID duration;

@end

NS_ASSUME_NONNULL_END
