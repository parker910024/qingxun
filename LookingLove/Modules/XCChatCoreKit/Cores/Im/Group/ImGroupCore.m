//
//  ImGroupCore.m
//  BberryCore
//
//  Created by 卫明何 on 2018/6/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "ImGroupCore.h"


@interface ImGroupCore()
<
    NIMTeamManagerDelegate
>
@end

@implementation ImGroupCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].teamManager addDelegate:self];
    }
    return self;
}

#pragma mark - Public

- (NSMutableArray *)requestGroupList {
    return [[[NIMSDK sharedSDK].teamManager allMyTeams] mutableCopy];
}



#pragma mark - NIMTeamManagerDelegate



@end
