//
//  VersionCore.h
//  BberryCore
//
//  Created by 卫明何 on 2017/11/9.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCore.h"
#import "VersionInfo.h"

@interface VersionCore : BaseCore
@property(nonatomic, assign)BOOL loadingData;//yes
@property(nonatomic, strong)VersionInfo *versionInfo;

@property (nonatomic, strong) NSString  *exchangeRate;//[XCKeyWordTool sharedInstance].xcExchangeMethod萌币的比例

/**
 是否在
 */
- (void)isLoadingData;

/*
  [XCKeyWordTool sharedInstance].xcExchangeMethod萌币的比例
 */

- (NSString *)getExchangeRate;

//兔兔 在登录界面是不是显示可以用耳伴号登录
- (void)getVestBagShowErBanLogin;

@end
