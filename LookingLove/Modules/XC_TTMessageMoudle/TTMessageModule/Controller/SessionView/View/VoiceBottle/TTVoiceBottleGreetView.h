//
//  TTVoiceBottleGreetView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/12.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTVoiceBottleGreetView : UIView
/** 背景图*/
@property (nonatomic,strong, readonly) UIImageView *backImageView;
/** 设置显示的内容*/
@property (nonatomic,strong) NSString *content;


@end

NS_ASSUME_NONNULL_END
