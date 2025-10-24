//
//  TTDisplayModelMaker.h
//  TTPlay
//
//  Created by 卫明 on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

//model
#import "TTMessageDisplayModel.h"
#import "Attachment.h"
#import "FaceSendInfo.h"
#import "FaceReceiveInfo.h"

//helper
#import "TTMessageHelper.h"
#import "XCTheme.h"
#import "NSString+SpecialClean.h"
#import "NSString+JsonToDic.h"
#import "NobleBroadcastInfo.h"
#import "TTMessageStrategies.h"
#import "TTMessageViewLayout.h"
#import "TTMessageViewConst.h"
#import "CALayer+QiNiu.h"

//att
#import <YYText/YYText.h>
#import "BaseAttrbutedStringHandler.h"
#import "BaseAttrbutedStringHandler+RoomMessage.h"

//core
#import "AuthCore.h"
#import "FaceCore.h"
#import "VersionCore.h"
#import "RoomMagicCore.h"

//const
#import "TTMessageViewConst.h"

//client
#import "ImRoomCoreClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker : NSObject

+ (instancetype)shareMaker;

- (TTMessageDisplayModel *)makeMessageDisplayModelWithMessage:(NIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
