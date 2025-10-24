//
//  FeedbackCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/7/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedbackCoreClient <NSObject>
- (void)onRequestFeedbackSuccess;
- (void)onRequestFeedbackFailth;
@end
