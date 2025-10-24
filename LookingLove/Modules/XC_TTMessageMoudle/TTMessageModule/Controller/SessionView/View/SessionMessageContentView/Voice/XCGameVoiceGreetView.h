//
//  XCGameVoiceGreetView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/12.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCGameVoiceBottleAttachment.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^GreetClickBlock)(UIButton *sender);

@interface XCGameVoiceGreetView : UIView
/** 打个招呼*/
@property (nonatomic,strong, readonly) UIButton *greetButton;

/** 点击打招呼*/
@property (nonatomic,copy) GreetClickBlock clickGreet;

/** 打招呼的实体*/
@property (nonatomic,strong) XCGameVoiceBottleAttachment *voiceAttach;

@end

NS_ASSUME_NONNULL_END
