//
//  TTGuildGroupCreateModel.h
//  TuTu
//
//  Created by lvjunhang on 2019/1/9.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuildHallGroupInfo.h"
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN


@interface TTGuildGroupCreateModel : NSObject
@property (nonatomic, assign) GuildHallGroupType type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, strong) NSArray<UserInfo *> *selectingUserArray;

@end

NS_ASSUME_NONNULL_END
