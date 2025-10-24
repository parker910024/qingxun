//
//  TTVoiceNewUserGuide.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/18.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShowBlock)(BOOL show);

@interface TTVoiceNewUserGuide : UIView

/**
 *
 */
@property (nonatomic,copy) ShowBlock show;

/** 展示新手引导*/
- (void)showVoiceNewUserGuide;



@end

NS_ASSUME_NONNULL_END
