//
//  TTOutputInfoView.h
//  TuTu
//
//  Created by Macx on 2018/12/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "TTOutputEnumConst.h"
NS_ASSUME_NONNULL_BEGIN

/**
 点击 view 的事件
 // 未绑定手机
 // 为填写提现账号
 */
typedef void(^TTOutputInfoViewClickHandler)(void);

@class ZXCInfo;

@interface TTOutputInfoView : UIView

@property (nonatomic, copy) TTOutputInfoViewClickHandler infoViewClickHandler;
@property (nonatomic, strong) ZXCInfo *zxcInfo;
@property (nonatomic, assign) TTOutputViewType outputType;

@end

NS_ASSUME_NONNULL_END
