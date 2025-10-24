//
//  TTSendPresentUserInfo.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/23.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSendPresentUserInfo.h"
#import <YYModel/YYModel.h>

@interface TTSendPresentUserInfo()
@property (nonatomic, copy, readwrite) NSString *nickname;
@property (nonatomic, assign, readwrite) UserID uid;

@end

@implementation TTSendPresentUserInfo

+ (instancetype)initWithNickname:(NSString *)nickname userID:(UserID)uid {
    TTSendPresentUserInfo *model = [[TTSendPresentUserInfo alloc] init];
    model.nickname = [nickname copy];
    model.uid = uid;
    
    return model;
}

- (NSString *)description {
    return self.yy_modelDescription;
}
@end
