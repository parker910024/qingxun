//
//  TTLittleWorldSessionViewController.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "NIMSessionViewController.h"
#import "TTLittleWorldInputView.h"
#import "TTSendGiftView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTLittleWorldSessionViewController : NIMSessionViewController
<TTSendGiftViewDelegate>
/** 输入框*/
@property (nonatomic,strong) TTLittleWorldInputView *publicChatInputView;
@end

NS_ASSUME_NONNULL_END
