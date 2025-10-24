//
//  TTPublicHistoryMessageDataProvider.h
//  TuTu
//
//  Created by 卫明 on 2018/11/13.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NIMKitMessageProvider.h"

//core
#import "PublicChatroomCore.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTPublicHistoryMessageDataProviderDelegate <NSObject>

- (void)onProviderGetNoData;

- (void)onProvideGetData;

@end

@interface TTPublicHistoryMessageDataProvider : NSObject <NIMKitMessageProvider>

@property (nonatomic,strong) NIMSession *session;

@property (nonatomic,assign) NSInteger limit;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,assign) TTPublicHistoryMessageDataProviderType type;

@property (nonatomic,weak) id<TTPublicHistoryMessageDataProviderDelegate> delegate;

- (instancetype)initWithSession:(NIMSession *)session limit:(NSInteger)limit;



@end

NS_ASSUME_NONNULL_END
