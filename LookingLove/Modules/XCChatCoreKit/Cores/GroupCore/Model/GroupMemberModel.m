//
//  GroupMemberModel.m
//  BberryCore
//
//  Created by 卫明何 on 2018/6/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "GroupMemberModel.h"

@implementation GroupMemberModel


- (NSString *)nick
{
    if (_nick) {
        return _nick;
    }else{
        return @"暂无昵称";
    }
}

- (NSString *)avatar
{
    if (_avatar) {
        return _avatar;
    }else{
        return @"https://img.erbanyy.com/logo.png";
    }
}

@end
