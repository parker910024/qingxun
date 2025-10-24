//
//  TTPublicHistoryMessageDataProvider.m
//  TuTu
//
//  Created by 卫明 on 2018/11/13.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicHistoryMessageDataProvider.h"


//core
#import "ImPublicChatroomCore.h"


@interface TTPublicHistoryMessageDataProvider ()

@property (strong, nonatomic) NSMutableArray *msgArray;

@property (assign, nonatomic) NSTimeInterval lastTime;


@end

@implementation TTPublicHistoryMessageDataProvider

- (instancetype)initWithSession:(NIMSession *)session limit:(NSInteger)limit {
    if (self = [super init]) {
        _limit = limit;
        _session = session;
    }
    return self;
}

- (void)pullDown:(NIMMessage *)firstMessage handler:(NIMKitDataProvideHandler)handler {
    [self remoteFetchType:self.type handler:handler];
}

- (void)remoteFetchType:(TTPublicHistoryMessageDataProviderType)type handler:(NIMKitDataProvideHandler)handler {
    NSString *publicChatroomId = [NSString stringWithFormat:@"%ld",(long)GetCore(ImPublicChatroomCore).publicChatroomId];
    switch (type) {
        case TTPublicHistoryMessageDataProviderType_AtMe:
        {
            @weakify(self);
            [GetCore(PublicChatroomCore)fetchAtMeMessageByChatroomid:publicChatroomId count:20 pageCount:self.currentPage success:^(NSArray<NIMMessage *> * messages) {
                @strongify(self);
                if (messages.count > 0) {
                    self.currentPage++;
                }
                if (self.currentPage == 1 && messages.count == 0) {
                    if ([self.delegate respondsToSelector:@selector(onProviderGetNoData)]) {
                        [self.delegate onProviderGetNoData];
                    }
                }else {
                    if ([self.delegate respondsToSelector:@selector(onProvideGetData)]) {
                        [self.delegate onProvideGetData];
                    }
                }
                handler(nil,messages);
            } failure:^(NSNumber * resCode, NSString * message) {
                NSDictionary *info = @{NSLocalizedDescriptionKey:message};
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:info];
                handler(error,nil);
            }];
        }
            break;
        case TTPublicHistoryMessageDataProviderType_FromMe:
        {
            @weakify(self);
            [GetCore(PublicChatroomCore)fetchSendFromMeMessageByChatroomid:publicChatroomId count:20 pageCount:self.currentPage success:^(NSArray<NIMMessage *> * messages) {
                @strongify(self);
                if (messages.count > 0) {
                    self.currentPage++;
                }
                
                NSMutableArray *messageArray = [NSMutableArray arrayWithArray:messages];
                
                for (int i = 0; i < messageArray.count; i++) {
                    NIMMessage *message = messageArray[i];
                    if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
                        NIMCustomObject *obj = message.messageObject;
                        Attachment *attment = (Attachment *)obj.attachment;
                        if (attment.first == Custom_Noti_Header_CPGAME_PublicChat_Respond) {
                            [messageArray removeObject:message];
                            i--;
                        }
                        if (attment.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification) {
                            if (attment.second == Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_CancelGame) {
                                [messageArray removeObject:message];
                                i--;
                            }
                        }
                    }
                }
                
                if (self.currentPage == 1 && messages.count == 0) {
                    if ([self.delegate respondsToSelector:@selector(onProviderGetNoData)]) {
                        [self.delegate onProviderGetNoData];
                    }
                }else {
                    if ([self.delegate respondsToSelector:@selector(onProvideGetData)]) {
                        [self.delegate onProvideGetData];
                    }
                }
                
                
                handler(nil,messageArray);
            } failure:^(NSNumber * resCode, NSString * message) {
                NSDictionary *info = @{NSLocalizedDescriptionKey:message};
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:info];
                handler(error,nil);
            }];
        }
            break;
        default:
            break;
    }
    
}

@end
