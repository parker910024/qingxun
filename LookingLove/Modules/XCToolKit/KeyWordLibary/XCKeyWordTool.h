//
//  XCKeyWordTool.h
//  XCToolKit
//
//  Created by KevinWang on 2018/10/13.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCKeyWordTool : NSObject

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) NSString *xcz;
@property (nonatomic, copy) NSString *xczAccount;
@property (nonatomic, copy) NSString *xcGetCF;
@property (nonatomic, copy) NSString *xcRedColor;
@property (nonatomic, copy) NSString *xcExchangeMethod;
@property (nonatomic, copy) NSString *xcIn;
@property (nonatomic, copy) NSString *xcCF;
@property (nonatomic, copy) NSString *xcShare;
@property (nonatomic, copy) NSString *xcRabbit;
@property (nonatomic, copy) NSString *xcForLight;

/** 我的app名字*/
@property (nonatomic,copy) NSString *myAppName;

+ (instancetype)sharedInstance;

@end
