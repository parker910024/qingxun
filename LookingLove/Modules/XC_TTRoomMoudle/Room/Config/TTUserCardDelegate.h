//
//  TTUserCardDelegate.h
//  TuTu
//
//  Created by KevinWang on 2018/11/25.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSendGiftView.h"

@interface TTUserCardDelegate : NSObject<TTSendGiftViewDelegate>

+ (instancetype)defaultDelegate;

@end
