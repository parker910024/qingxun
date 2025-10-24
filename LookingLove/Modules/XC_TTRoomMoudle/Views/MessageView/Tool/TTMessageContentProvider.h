//
//  TTMessageContentProvider.h
//  TTPlay
//
//  Created by 卫明 on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//model
#import "TTMessageDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageContentProvider : NSObject

+ (instancetype)shareProvider;

@property (strong, nonatomic) NSMutableArray<TTMessageDisplayModel *> *messages;

@end

NS_ASSUME_NONNULL_END
