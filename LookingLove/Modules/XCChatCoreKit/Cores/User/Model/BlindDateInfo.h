//
//  BlindDateInfo.h
//  CeEr
//
//  Created by jiangfuyuan on 2020/12/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "BaseObject.h"
#import "LoveRoomHeadWear.h"
NS_ASSUME_NONNULL_BEGIN

@interface BlindDateInfo : BaseObject

@property (nonatomic, strong) NSString *chooseUid; // 相亲房选择的对象uid
@property (nonatomic, assign) BOOL publish;  // 是否已经被公开心动(true -- 是, false -- 否)
@property (nonatomic, strong) NSArray *guests; // 选自己的嘉宾uid(有多个)
@property (nonatomic, strong) LoveRoomHeadWear *roomHeadwearVo; // 相亲房帽子
@property (nonatomic, strong) NSString *chooseMic; // 选择的对象Mic

@end

NS_ASSUME_NONNULL_END
