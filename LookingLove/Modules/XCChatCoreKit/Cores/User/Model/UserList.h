//
//  UserList.h
//  BberryCore
//
//  Created by gzlx on 2017/7/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface UserList :BaseObject

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *avatarUrl;
@property (copy, nonatomic) NSString *nickname;

@end
