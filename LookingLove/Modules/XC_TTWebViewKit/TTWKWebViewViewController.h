//
//  TTWKWebViewViewController.h
//  TuTu
//
//  Created by 卫明 on 2018/11/20.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "XCWKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^H5NotifyAppRefreshHandler)(WebViewNotifyAppActionStatusType statusType);

@interface TTWKWebViewViewController : XCWKWebViewController

@property (nonatomic, copy) H5NotifyAppRefreshHandler notifyRefreshHandler;

/// 请求关闭处理
@property (nonatomic, copy) void (^dismissRequestHandler)(void);

@end

NS_ASSUME_NONNULL_END
