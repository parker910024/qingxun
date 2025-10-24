//
//  TTDressUpBuyOrPresentView.h
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 购买头饰或者座驾的弹窗view 显示的样式

 - TTDressUpViewStyleBoth: 两者都显示
 - TTDressUpViewStyleCoin: 只显示金币
 - TTDressUpViewStyleCarrot: 只显示萝卜
 */
typedef NS_ENUM(NSUInteger, TTDressUpViewStyle) {
    TTDressUpViewStyleCoin = 0,
    TTDressUpViewStyleCarrot = 1,
    TTDressUpViewStyleBoth = 2,
    TTDressUpViewStyleNotMoney = 3,
};


/**
 购买商品使用的货币的类型

 - TTDressUpBuyTypeCoin: 金币购买
 - TTDressUpBuyTypeCarrot: 萝卜购买
 */
typedef NS_ENUM(NSUInteger, TTDressUpBuyType) {
    TTDressUpBuyTypeCoin = 0,
    TTDressUpBuyTypeCarrot = 1,
};

typedef void(^cancelBlock)(void);
typedef void(^enterClickHandelr)(TTDressUpViewStyle style, TTDressUpBuyType type);
@interface TTDressUpBuyOrPresentView : UIView
@property (nonatomic, copy) cancelBlock  cancelBlock;//
@property (nonatomic, copy) enterClickHandelr  ensureBlock;//
@property (nonatomic, strong) NSString  *ensureBtnTitle;//
@property (nonatomic, assign) TTDressUpViewStyle style;

/**
 根据 style 创建不同富文本的内容

 @param style 显示的风格
 @param title 标题
 @param message 内容
 @param attriMessageString 内容富文本样式
 @param priceString 价格
 @return view
 */
- (instancetype)initWithStyle:(TTDressUpViewStyle)style
                        title:(NSString *)title
                      message:(NSString *)message
           attriMessageString:(NSAttributedString *)attriMessageString
                  priceString:(NSString *)priceString carrotString:(NSString *)carrotString;
@end
