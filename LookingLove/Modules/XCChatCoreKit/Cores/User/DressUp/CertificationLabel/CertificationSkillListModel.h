//
//  CertificationSkillListModel.h
//  XCChatCoreKit
//
//  Created by new on 2019/3/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CertificationSkillListModel : BaseObject

@property (nonatomic, assign) UserID skillID;
@property (nonatomic, assign) UserID liveId;
@property (nonatomic, strong) NSString *skillName;
@property (nonatomic, strong) NSString *skillPicture;
@property (nonatomic, strong) NSString *skillType;
@property (nonatomic, assign) UserID status;
@property (nonatomic, assign) UserID valid;
@property (nonatomic, assign) UserID hasUse;
@end

NS_ASSUME_NONNULL_END
