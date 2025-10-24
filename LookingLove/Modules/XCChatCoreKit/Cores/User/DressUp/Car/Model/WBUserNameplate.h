//
//  WBUserNameplate.h
//  WanBan
//
//  Created by ShenJun_Mac on 2020/9/4.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBUserNameplate : BaseObject
@property (nonatomic, strong) NSString *days; //使用时间
@property (nonatomic, strong) NSString *nameplateId;//id
@property (nonatomic, strong) NSString *name;//铭牌名字
@property (nonatomic, strong) NSString *iconPic;//铭牌图标
@property (nonatomic, strong) NSString *isCustomWord;//是否自定义( 0-- 否, 1 -- 是)
@property (nonatomic, strong) NSString *fixedWord;//文案
@property (nonatomic, assign) NSInteger expireDate; //    剩余天数
@property (nonatomic, assign) NSInteger expireTime;//有效期
@property (nonatomic, assign) NSInteger  used;//是否使用(0 -- 未使用, 1 -- 使用中, 2 --待制作, 3 -- 已制作 )后面两个针对自定义文案的铭牌
@property (nonatomic, strong) NSString *desc;//铭牌说明

@end

NS_ASSUME_NONNULL_END
