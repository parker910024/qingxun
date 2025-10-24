//
//  HomeRankingInfo.h
//  BberryCore
//
//  Created by Mac on 2017/11/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseObject.h"

@interface HomeRankingInfo : BaseObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *erbanNo;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) int gender;
@property (nonatomic, assign) int totalNum;
@end
