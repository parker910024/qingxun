//
//  CertificationModel.h
//  XCChatCoreKit
//
//  Created by new on 2019/3/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "CertificationSkillListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CertificationModel : BaseObject

@property (nonatomic, assign) BOOL liveTag;
@property (nonatomic, strong) NSString *liveSkillName;
@property (nonatomic, strong) NSString *skillTag;
@property (nonatomic, strong) NSMutableArray<CertificationSkillListModel *> *liveSkillVoList;

@end

NS_ASSUME_NONNULL_END
