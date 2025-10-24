//
//  TTTopAlertViewTool.h
//  TuTu
//
//  Created by Macx on 2018/11/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCBadNetworkAlertView.h"
#import "LLForceUpdateView.h"
typedef enum {
    TTAlertType_Update = 1,
    TTAlertType_badNetwork = 2
} TTAlertType;

@interface TTTopAlertViewTool : UIView
@property (nonatomic, strong) XCBadNetworkAlertView *badNetworkAlertView;

- (void)ttShowBadNetworkAlertView;
- (void)ttShowUpdateViewWithDesc:(NSString *)desc version:(NSString *)version;
- (void)ttShowForceUpdateViewWithDesc:(NSString *)desc version:(NSString *)version;

+ (instancetype)shareTTTopAlertViewTool;
@end
