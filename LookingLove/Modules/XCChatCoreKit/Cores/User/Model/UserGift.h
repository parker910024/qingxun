//
//  UserGift.h
//  BberryCore
//
//  Created by demo on 2017/10/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
typedef enum {
    OrderType_Number = 1,
    OrderType_Price = 2
}OrderType;


@interface UserGift : BaseObject
@property (assign, nonatomic) UserID uid;
@property (copy, nonatomic) NSString * giftId;
@property (copy, nonatomic) NSString * reciveCount;
@property (nonatomic, strong)NSString *picUrl;
@property (nonatomic, strong)NSString *giftName;
// 萝卜礼物数量 ps: 和之前的字段差了一个字母 - -
@property(nonatomic, assign) NSInteger receiveCount;
@end


