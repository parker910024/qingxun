//
//  RoomBounsListInfo.h
//  BberryCore
//
//  Created by KevinWang on 2018/7/3.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "BaseObject.h"

typedef enum : NSUInteger {
    RankType_Send = 0,//贡献榜
    RankType_Receive = 1,//魅力榜
} RankType;

typedef enum : NSUInteger {
    RankDataType_Day = 0,//日榜
    RankDataType_Week = 1,//月榜
    RankDataType_Total = 2,//总榜
} RankDataType;

@interface RoomBounsListInfo : BaseObject

@property (assign, nonatomic) UserID uid;
@property (assign, nonatomic) UserID erbanNo;
@property (copy, nonatomic) NSString *nick;
@property (copy, nonatomic) NSString *avatar;
@property (assign, nonatomic) UserGender gender;
@property (assign, nonatomic) BOOL hasPrettyNo;
@property (copy, nonatomic) NSString *experSeq;//排名用户经验等级
@property (copy, nonatomic) NSString *experUrl;//排名用户经验等级名称
@property (copy, nonatomic) NSString *charmSeq;//排名用户魅力等级
@property (copy, nonatomic) NSString *charmUrl;//魅力图片
@property (nonatomic,strong) NSString *badge;//徽章
@property (nonatomic,strong) NSString *micDecorate;//头饰
@property (copy, nonatomic) NSString *goldAmount;//房间send/receive金币总数
@property (copy, nonatomic) NSString *ranking;//排名
@property (nonatomic,assign) BOOL hide;//是否榜单隐身

@property (nonatomic,assign) RankType rankType;//排行榜类型 贡献榜,魅力榜
@property (nonatomic,assign) RankDataType rankDateType;//排行榜数据类型 日,月,总
@end
