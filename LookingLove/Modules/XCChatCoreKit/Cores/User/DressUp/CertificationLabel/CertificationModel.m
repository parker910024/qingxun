//
//  CertificationModel.m
//  XCChatCoreKit
//
//  Created by new on 2019/3/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "CertificationModel.h"

@implementation CertificationModel

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"liveSkillVoList": CertificationSkillListModel.class
             };
}

@end
