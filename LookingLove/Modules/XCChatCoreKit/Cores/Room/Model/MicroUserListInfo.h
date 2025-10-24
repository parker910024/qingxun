//
//  MicroUserListInfo.h
//  BberryCore
//
//  Created by gzlx on 2017/8/9.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface MicroUserListInfo : BaseObject

@property (assign, nonatomic) UserID uid; //uid
@property (copy, nonatomic) NSString *nick; //用户昵称
@property (copy, nonatomic) NSString *avatar; //用户头像
@property (copy, nonatomic) NSString *seqNo; //排序编号
@property (assign, nonatomic) NSInteger status; //用户状态  1房主发起邀请中，2在麦序上

@end
