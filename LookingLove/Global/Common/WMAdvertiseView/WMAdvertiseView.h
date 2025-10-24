//
//  AdvertiseView.h
//  JinSeShiJi
//
//  Created by zn on 16/8/10.
//
//

#import <UIKit/UIKit.h>
#import "AdCache.h"

#define kUserDefaults [NSUserDefaults standardUserDefaults]
static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";
@interface WMAdvertiseView : UIView

/** 显示广告页面方法*/
- (void)show;

/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) UIImage *adImage;

@property (nonatomic, copy) void(^dismissHandler)(BOOL shouldJump); //闪屏消失回调

@end
