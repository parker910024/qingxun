//
//  TTRoomGiftValueGuideView.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/4/28.
//  房间礼物值首次启动引导页面

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTRoomGiftValueGuideView : UIView

/**
 引导完成回调
 */
@property (nonatomic, copy) void (^didFinishGuide)(void);

@end

NS_ASSUME_NONNULL_END
