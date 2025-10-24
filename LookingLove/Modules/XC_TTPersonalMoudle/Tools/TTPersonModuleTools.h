//
//  TTPersonModuleTools.h
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DressUpModel;

@interface TTPersonModuleTools : NSObject

/*————      装扮 Start    ——————*/
//判断 装扮类型获取 图标
+ (NSString *)getNameFromDressUpLimitType:(DressUpModel *)model;

//价钱富文本
+ (NSAttributedString *)getPriceAttriButeStringWithPrice:(NSString *)price;

/*————      装扮 End    ——————*/


@end
