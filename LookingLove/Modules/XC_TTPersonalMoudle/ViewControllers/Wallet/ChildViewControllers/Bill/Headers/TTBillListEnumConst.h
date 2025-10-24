//
//  TTBillListEnumConst.h
//  TuTu
//
//  Created by lee on 2018/11/13.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#ifndef TTBillListEnumConst_h
#define TTBillListEnumConst_h

/**
 根据类型 使用不同样式的 cell
 
 - TTBillListViewTypeGiftIn: 礼物支出
 - TTBillListViewTypeGiftOut: 礼物收入
 - TTBillListViewTypeCodeRed: 提现
 - TTBillListViewTypeRecharge: 充值
 - TTBillListViewTypeRedBalance: redColor
 - TTBillListViewTypeRedBalance: 贵族
 - TTBillListViewTypeRedColor : redColor记录
 - TTBillListViewTypeGiftInCarrot : 萝卜礼物收入
 - TTBillListViewTypeGiftOutCarrot : 萝卜礼物支出
 */
typedef NS_ENUM(NSUInteger, TTBillListViewType) {
    /**  - TTBillListViewTypeGiftIn: 礼物支出 */
    TTBillListViewTypeGiftIn = 0,
    /**  - TTBillListViewTypeGiftOut: 礼物收入*/
    TTBillListViewTypeGiftOut = 1,
    /**  - TTBillListViewTypeCodeRed: 提现 */
    TTBillListViewTypeCodeRed = 2,
    /**  - TTBillListViewTypeRecharge: 充值 */
    TTBillListViewTypeRecharge = 3,
    /**  - TTBillListViewTypeRedBalance: 红包 */
    TTBillListViewTypeRedBalance = 4,
    /**  - TTBillListViewTypeRedBalance: 贵族 */
    TTBillListViewTypeNoble = 5,
    /**  - TTBillListViewTypeRedColor : 红包记录 */
    TTBillListViewTypeRedColor = 6,
    /** TTBillListViewTypeGiftInCarrot : 萝卜礼物收入 */
    TTBillListViewTypeGiftInCarrot = 7,
    /** TTBillListViewTypeGiftOutCarrot ： 萝卜礼物支出 */
    TTBillListViewTypeGiftOutCarrot = 8,
};

#endif /* TTBillListEnumConst_h */
