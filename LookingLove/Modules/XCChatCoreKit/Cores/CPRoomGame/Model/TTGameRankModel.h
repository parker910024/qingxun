//
//  TTGameRankModel.h
//  TTPlay
//
//  Created by new on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "TTGameRankListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTGameRankModel : BaseObject

@property (nonatomic, strong) NSString *internal;
@property (nonatomic, strong) NSMutableArray<TTGameRankListModel *> *listModelArray;

@end

NS_ASSUME_NONNULL_END
