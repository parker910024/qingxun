//
//  TTWithdrawEnumConst.h
//  TuTu
//
//  Created by lee on 2018/11/17.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#ifndef TTOutputEnumConst_h
#define TTOutputEnumConst_h

/**
 提现类型
 
 - TTWithdrawViewTypeDiamond: 钻石提现
 - TTWithdrawViewTypeRedPacket: 红包提现
 */
typedef NS_ENUM(NSUInteger, TTOutputViewType) {
    /** 钻石提现 */
    TTOutputViewTypexcCF = 0,
    /** 红包提现 */
    TTOutputViewTypexcRedColor = 1,
};

static NSString *const kHelloWorld_blue = @"https://img.erbanyy.com/helloworld.png";
static NSString *const kHelloWorld_gray = @"https://img.erbanyy.com/goodbyeworld.png";


#endif /* TTWithdrawEnumConst_h */
