//
//  TTWkGameViewController.h
//  TuTu
//
//  Created by new on 2019/1/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWKWebViewViewController.h"

typedef void(^ClickDifferentButton)(NSString *typeString,NSString *gameId);

NS_ASSUME_NONNULL_BEGIN

@interface TTWkGameViewController : TTWKWebViewViewController

@property (nonatomic, strong) NSString *gameUrlString;
@property (nonatomic, assign) BOOL watching;
@property (nonatomic, strong) NSString *superviewType;
@property (nonatomic, copy) ClickDifferentButton clickButton;

@end

NS_ASSUME_NONNULL_END
