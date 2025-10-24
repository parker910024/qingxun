//
//  MicroListInfo.h
//  BberryCore
//
//  Created by chenran on 2017/6/2.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MicroUserListInfo.h"
#import "NSObject+YYModel.h"
#import "BaseObject.h"

@interface MicroListInfo : BaseObject
@property(nonatomic, assign)UserID uid;
@property(nonatomic, strong)NSArray<MicroUserListInfo *> *data;
@end
