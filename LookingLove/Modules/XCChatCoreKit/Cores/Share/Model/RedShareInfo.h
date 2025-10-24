//
//  RedShareInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/25.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedShareInfo : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *imgUrl;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *showUrl;

@property (nonatomic, strong) NSDictionary *nativeParams;//原生扩张参数

@property (copy, nonatomic) NSString *link; //回传给后台的url

@end
