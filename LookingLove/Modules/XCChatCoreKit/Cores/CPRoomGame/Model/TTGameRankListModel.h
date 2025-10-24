//
//  TTGameRankListModel.h
//  TTPlay
//
//  Created by new on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRankListModel : BaseObject

@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSArray *userList;

@end

NS_ASSUME_NONNULL_END
