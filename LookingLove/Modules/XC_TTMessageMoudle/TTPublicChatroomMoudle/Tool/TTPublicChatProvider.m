//
//  TTPublicChatProvider.m
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatProvider.h"


@implementation TTPublicChatProvider

+ (NIMUser *)fetchUserInfoByUser:(NSString *)uid {
    return [[NIMSDK sharedSDK].userManager userInfo:uid];
}

@end
