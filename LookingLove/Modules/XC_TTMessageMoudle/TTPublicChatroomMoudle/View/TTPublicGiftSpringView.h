//
//  TTPublicGiftSpringView.h
//  TuTu
//
//  Created by 卫明 on 2018/11/2.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//model
#import "GiftAllMicroSendInfo.h"
#import "SVGAParserManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicGiftSpringView : UIView

/**
 礼物协议
 */
@property (strong, nonatomic, nullable) GiftAllMicroSendInfo *info;

/**
 动态背景
 */
@property (strong, nonatomic) SVGAImageView *svgaImageView;

@end

NS_ASSUME_NONNULL_END
