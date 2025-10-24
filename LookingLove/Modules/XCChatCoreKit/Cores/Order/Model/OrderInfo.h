//
//  OrderInfo.h
//  BberryCore
//
//  Created by chenran on 2017/6/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef enum {
    Order_Status_Not_Complete = 1,//订单未完成
    Order_Status_In_Hand = 2,//订单处理中
    Order_Status_Complete = 3,//订单已完成
    Order_Status_Exception = 4//订单异常
}OrderStatus;
@interface OrderInfo : BaseObject
@property(nonatomic, assign) UserID uid;
@property(nonatomic, assign) UserID prodUid;
@property(nonatomic, assign) NSInteger totalMoney;
@property(nonatomic, assign) NSInteger servDura;
@property(nonatomic, assign) NSInteger leftServDura;
@property(nonatomic, assign) OrderStatus curStatus;
@property(nonatomic, strong) NSString *orderId;
@property(nonatomic, strong) NSString *objId;
@property(nonatomic, copy) NSString *userImg;  //用户头像
@property(nonatomic, copy) NSString *prodImg; //声优头像
@property(nonatomic, copy) NSString *prodName; //声优名字
@property (copy, nonatomic) NSString *userName; //  用户名字
@property (assign, nonatomic) NSInteger remainDay; //剩余天数
@end
