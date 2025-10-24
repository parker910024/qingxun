//
//  LTVibrationTool.m
//  LTChat
//
//  Created by apple on 2019/9/30.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTVibrationTool.h"
#import <UIKit/UIKit.h>

@implementation LTVibrationTool

+ (void)showVibrationAction {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGenertor impactOccurred];
    } else {
    }
}

@end
