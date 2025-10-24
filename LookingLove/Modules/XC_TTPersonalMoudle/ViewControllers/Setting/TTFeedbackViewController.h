//
//  TTFeedbackViewController.h
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

typedef NS_ENUM(NSInteger, TTFeedbackSouce) {//反馈来源
    TTFeedbackSouceSetting = 1,//SET_UP_PAGE -- 设置页
    TTFeedbackSouceDraw,//DRAW -- 转盘活动
    TTFeedbackSouceRoomRed,//ROOM_RED -- 房间红包
};

@interface TTFeedbackViewController : BaseUIViewController
@property (nonatomic, assign) TTFeedbackSouce souce;//反馈源
@end
