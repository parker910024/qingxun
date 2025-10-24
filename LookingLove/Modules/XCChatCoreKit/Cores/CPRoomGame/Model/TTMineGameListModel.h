//
//  TTMineGameListModel.h
//  XCChatCoreKit
//
//  Created by new on 2019/3/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMineGameListModel : BaseObject

@property (nonatomic, assign) UserID uid;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, assign) UserID winCount;
@property (nonatomic, strong) NSString *gamePicture;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, strong) NSString *platform;

@end

NS_ASSUME_NONNULL_END
