//
//  XCBoxBuykeyView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxCore.h"

@protocol XCBoxBuykeyViewDelegate<NSObject>

@optional
//取消购买
- (void)cancelBuyKey;

/**
 确认购买

 @param keyNum 确认购买的钥匙数量
 */
- (void)ensureBuyKeyWithKeyNumber:(NSInteger)keyNum type:(XCBoxBuyKeyType)type;

@end


typedef void(^cancelBuyKeyBlock)(void);
typedef void(^ensureBuyKeyBlock)(NSInteger keyNum,XCBoxBuyKeyType type);

@interface XCBoxBuykeyView : UIView

@property (nonatomic, assign) NSInteger  keyPrice;//钥匙的单价

@property (nonatomic, assign) NSInteger  needKeyNumber;//需要的钥匙数量

@property (nonatomic, weak) id<XCBoxBuykeyViewDelegate>  delegate;//
@property (nonatomic, copy) cancelBuyKeyBlock  cancelBuyKeyBlock;//
@property (nonatomic, copy) ensureBuyKeyBlock  ensureBuyKeyBlock;//

/**
 是否是至尊金蛋
 */
@property (nonatomic, assign) BOOL isDiamondBox;

- (instancetype)initWithNeedKey;
@end
