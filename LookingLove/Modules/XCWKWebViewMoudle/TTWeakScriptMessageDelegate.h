//
//  TTWeakScriptMessageDelegate.h
//  TTPlay
//
//  Created by new on 2019/2/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TTWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;	

@end

NS_ASSUME_NONNULL_END
