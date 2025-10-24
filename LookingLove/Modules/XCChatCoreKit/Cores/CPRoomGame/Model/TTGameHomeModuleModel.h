//
//  TTGameHomeModuleModel.h
//  XCChatCoreKit
//
//  Created by new on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

@class TTHomeV4DetailData;
NS_ASSUME_NONNULL_BEGIN

@interface TTGameHomeModuleModel : BaseObject
// 主页运营可配置模块 
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger moduleId;
@property (nonatomic, assign) UserID seqNo;
@property (nonatomic, strong) NSArray<TTHomeV4DetailData *> *data;
@property (nonatomic, assign) NSInteger listNum;
@property (nonatomic, assign) NSInteger maxNum;

@end

NS_ASSUME_NONNULL_END
