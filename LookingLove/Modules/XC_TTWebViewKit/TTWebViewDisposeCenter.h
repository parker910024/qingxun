//
//  TTWebViewHandleCenter.h
//  TuTu
//
//  Created by 卫明 on 2018/11/20.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTWebViewDisposeCenter : NSObject

@property (strong, nonatomic) WKWebView *webView;

@property (strong, nonatomic) UIView *containView;

@property (nonatomic,weak) UINavigationController *nav;

+ (instancetype)defaultCenter;

- (void)disposeNobleOrder:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
