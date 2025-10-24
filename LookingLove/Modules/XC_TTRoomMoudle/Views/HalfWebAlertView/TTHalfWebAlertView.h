//
//  TTHalfWebAlertView.h
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2019/12/4.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSUInteger, TTHalfWebAlertViewType) {
//    //居中
//    TTHalfWebAlertViewTypeMiddle = 0,
//    //从下到上
//    TTHalfWebAlertViewTypeBottomToTop = 1,
//
//};


@interface TTHalfWebAlertView : UIView
//类型
//@property (nonatomic, assign) TTHalfWebAlertViewType type;
/// 显示链接
@property (nonatomic, strong) NSURL *url;

// url地址，需要自动拼接域名
@property (nonatomic, copy) NSString *urlString;
/// 游戏弹窗消除请求回调
@property (nonatomic, copy) void (^gameDismissRequestHandler)(void);
/// 弹窗消除请求回调
@property (nonatomic, copy) void (^dismissRequestHandler)(void);
/// 关闭按钮图片
@property (nonatomic, strong) UIImage *closeButtonImage;
// 网页背景颜色
@property (nonatomic, strong) UIColor *webVCBgColor;

@end

NS_ASSUME_NONNULL_END
