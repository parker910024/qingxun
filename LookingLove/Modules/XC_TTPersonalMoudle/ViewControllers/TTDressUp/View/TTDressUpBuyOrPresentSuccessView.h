//
//  TTDressUpBuyOrPresentSuccessView.h
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ensureBlock)(void);

@interface TTDressUpBuyOrPresentSuccessView : UIView
@property (nonatomic, strong) UILabel  *titleLabel;//标题
@property (nonatomic, copy) ensureBlock  ensureBlock;//
@property (nonatomic, strong) NSString *titleString; // 当前的标题
@property (nonatomic, strong) NSString *imageString; // 图片
@property (nonatomic, assign) CGSize btnSize;  //  btn的大小
@property (nonatomic, strong) UIColor *btnColor; //  btn的背景颜色
@end
