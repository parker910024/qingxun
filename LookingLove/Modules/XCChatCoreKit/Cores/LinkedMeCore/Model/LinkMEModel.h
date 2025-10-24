//
//  LinkMEModel.h
//  BberryCore
//
//  Created by gzlx on 2017/7/17.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef NS_ENUM(NSUInteger, LinkedMESkipType) {
    LinkedMESkipType_InPage = 1, //app内
    LinkedMESkipType_Room   = 2, //房间
    LinkedMESkipType_H5     = 3, //H5
    LinkedMESkipType_Family = 4, //家族页
    LinkedMESkipType_WorldPage = 5, //小世界客态页
    LinkedMESkipType_DynamicDetail = 6, // 小世界动态详情页
};

@interface LinkMEModel : BaseObject

@property (nonatomic, copy) NSString *roomuid;//房间id
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *familyId;//家族id
@property (nonatomic, copy) NSString *worldId;//小世界id
@property (assign, nonatomic) LinkedMESkipType type;
@property (nonatomic, copy) NSString *url;//h5跳转链接
@property (nonatomic, copy) NSString *dynamicId; // 动态id
@end
