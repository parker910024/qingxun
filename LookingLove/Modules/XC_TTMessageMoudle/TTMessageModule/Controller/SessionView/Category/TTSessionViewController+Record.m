//
//  TTSessionViewController+Record.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSessionViewController+Record.h"
#import "XCHUDTool.h"

@implementation TTSessionViewController (Record)

- (void)onRecordFailed:(NSError *)error {
    
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath {
//    NIMAudioObject *player = [[NIMAudioObject alloc] initWithSourcePath:filepath];
//    if (player.duration < 1.0f) {
//        return NO;
//    }
    return YES;
}

- (void)showRecordFileNotSendReason {
    [XCHUDTool showErrorWithMessage:@"录音时间太短" inView:self.view];
}

@end
