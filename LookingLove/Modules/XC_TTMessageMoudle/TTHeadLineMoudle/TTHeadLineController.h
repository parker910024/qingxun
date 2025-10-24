//
//  TTHeadLineController.h
//  TuTu
//
//  Created by 卫明 on 2018/11/4.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "XCWKWebViewController.h"
#import "TTWKWebViewViewController.h"
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTHeadLineController : TTWKWebViewViewController
<
    ZJScrollPageViewChildVcDelegate
>

@end

NS_ASSUME_NONNULL_END
