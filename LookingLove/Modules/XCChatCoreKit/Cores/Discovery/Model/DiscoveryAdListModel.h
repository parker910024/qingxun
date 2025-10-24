//
//  DiscoveryAdListModel.h
//  BberryCore
//
//  Created by Macx on 2018/3/5.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

/*
 
 {
 "code":200,
 "data":[
 {
 "advName":"测试啊",
 "advIcon":"http://img.tian9k9.com/FvbRJRJgufTpntjatyfL8xx1yBQ5?imageslim",
 "skipType":3,
 "skipUri":"www.baidu.com"
 }
 ]
 }
 */
typedef NS_ENUM(NSUInteger, DiscoveryAdType) {
    DiscoveryAdTypePage = 1,
    DiscoveryAdTypeRoom,
    DiscoveryAdTypeWeb,
};


@interface DiscoveryAdListModel : BaseObject

@property (nonatomic, strong) NSString  *advName;//
@property (nonatomic, strong) NSString *skipUri;//地址
@property (nonatomic, assign) DiscoveryAdType skipType;// 1跳app页面，2跳聊天室，3跳h5页面
@property (nonatomic, copy)   NSString *advIcon;//图片 地址



@end
