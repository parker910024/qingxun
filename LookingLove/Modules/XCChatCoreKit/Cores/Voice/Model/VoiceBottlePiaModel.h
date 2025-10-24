//
//  VoiceBottlePiaModel.h
//  XCChatCoreKit
//
//  Created by fengshuo on 2019/6/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum{
    VoicePiaType_song= 1,//歌词
    VoicePiaType_lovePrattle = 2,//情话
}VoicePiaType;

@interface VoiceBottlePiaModel : BaseObject
/** pia剧本id */
@property (nonatomic,assign)  UserID pid;
/** 男 女 */
@property (nonatomic,assign)  UserGender gender;
/** 剧本内部*/
@property (nonatomic,strong) NSString *playBook;
/** 剧本标题*/
@property (nonatomic,strong) NSString *title;
/** 剧本的类型*/
@property (nonatomic,assign) VoicePiaType type;
@end

NS_ASSUME_NONNULL_END
