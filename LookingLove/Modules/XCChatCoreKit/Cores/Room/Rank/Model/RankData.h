//
//  RankData.h
//  BberryCore
//
//  Created by 卫明何 on 2018/4/20.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "UserInfo.h"
#import "RoomBounsListInfo.h"

@interface RankData : UserInfo

/**
 贡献度
 */
@property (nonatomic,copy) NSString *totalNum;

/**
 贵族id
 */
@property (nonatomic,assign) NSInteger nobleId;

/**
 贵族名称
 */
@property (nonatomic,strong) NSString *nobleName;

/**
 排行榜隐藏
 */
@property (nonatomic,assign) BOOL rankHide;

/**
 是否有靓号
 */
@property (nonatomic,assign) BOOL hasPrettyNo;

/**
 经验等级
 */
@property (nonatomic,assign) NSInteger experSeq;

/**
 魅力等级
 */
@property (nonatomic,assign) NSInteger charmSeq;

/**
 经验等级图片url
 */
@property (nonatomic,strong) NSURL *experUrl;

/**
 魅力等级图片url
 */
@property (nonatomic,strong) NSURL *charmUrl;

/**
 排行榜类型
 */
@property (nonatomic,assign) RankType rankType;

/**
 排行榜时间分类
 */
@property (nonatomic,assign) RankDataType rankDateType;


//=============================房间内排行榜属性=============================//

/**
 贵族勋章
 */
@property (nonatomic,strong) NSString *badge;

/**
 贵族头饰
 */
@property (nonatomic,strong) NSString *micDecorate;

/**
 排名
 */
@property (nonatomic,assign) NSInteger ranking;

/**
 贡献榜贡献度
 */
@property (nonatomic,copy) NSString *goldAmount;


/**
 是否榜单隐身
 */
@property (nonatomic,assign) BOOL hide;


/*--------------- 萌声 半小时榜  ------------------*/

/**
 房间标题
 */
@property (nonatomic,copy) NSString *roomTitle;

/**
 排序的序号，也就是名次。从1开始
 @discussion 兔兔为0，表示未上榜
 */
@property (nonatomic, assign) int seqNo;



@end
