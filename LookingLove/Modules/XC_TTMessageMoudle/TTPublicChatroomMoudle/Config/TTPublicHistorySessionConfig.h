//
//  TTPublicHistorySessionConfig.h
//  TuTu
//
//  Created by 卫明 on 2018/11/13.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTSessionConfig.h"
//provider
#import "TTPublicHistoryMessageDataProvider.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTPublicHistorySessionConfigDelegate <NSObject>

- (void)thereIsNoData;

- (void)thereIsData;

@end

@interface TTPublicHistorySessionConfig : TTSessionConfig

@property (strong, nonatomic) TTPublicHistoryMessageDataProvider *provider;

@property (nonatomic,weak) id<TTPublicHistorySessionConfigDelegate> delegate;

- (instancetype)initWithSession:(NIMSession *)session;

@end

NS_ASSUME_NONNULL_END
