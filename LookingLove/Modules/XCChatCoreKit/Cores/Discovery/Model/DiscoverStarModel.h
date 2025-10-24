//
//  DiscoverStarModel.h
//  XCChatCoreKit
//
//  Created by gzlx on 2018/8/29.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "BaseObject.h"

//avatar = "https://img.erbanyy.com/Fu85zgursRBxwavanZ66qQthpRGB?imageslim";
//erbanNo = 1341070;
//nick = "lzb_mouse";
//seqNo = 0;
//totalCount = 87200;
//uid = 29

@interface DiscoverStarModel : BaseObject
/** 头像*/
@property (nonatomic, copy) NSString * avatar;
/** 耳伴号*/
@property (nonatomic, copy) NSString *erbanNo;
/** 昵称*/
@property (nonatomic, copy) NSString * nick;
/** 排序*/
@property (nonatomic, assign)NSInteger seqNo;
/** uid*/
@property (nonatomic, assign) UserID uid;
@end
