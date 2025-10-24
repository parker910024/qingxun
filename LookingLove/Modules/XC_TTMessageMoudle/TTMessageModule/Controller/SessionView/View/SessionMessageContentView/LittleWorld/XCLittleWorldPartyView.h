//
//  XCLittleWorldPartyView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/9.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCLittleWorldAttachment.h"
NS_ASSUME_NONNULL_BEGIN

@interface XCLittleWorldPartyView : UIView

/** 小世界的实体*/
@property (nonatomic,strong) XCLittleWorldAttachment *littleWorldAttach;

/** 是不是自己发的*/
@property (nonatomic,assign) BOOL isOutGoing;

@end

NS_ASSUME_NONNULL_END
