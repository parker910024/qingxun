//
//  TabBarConfig.h
//  LookingLove
//
//  Created by lvjunhang on 2020/12/4.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  动态加载tabbar

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

//1：首页，2：广场页，3：消息页，4：个人页
typedef NS_ENUM(NSInteger, TabBarConfigItemCode) {
    TabBarConfigItemCodeHome = 1,
    TabBarConfigItemCodeSquare = 2,
    TabBarConfigItemCodeMessage = 3,
    TabBarConfigItemCodePersonal = 4,
};

@interface TabBarConfigItem : BaseObject<NSCoding>
@property (nonatomic, assign) TabBarConfigItemCode code;
@property (nonatomic, assign) BOOL needLoop;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *checkIcon;
@property (nonatomic, copy) NSString *uncheckIcon;
@property (nonatomic, copy) NSString *svgaUrl;

//MARK:客户端本地字段，下载图片流保存
@property (nonatomic, strong) NSData *checkIconData;
@property (nonatomic, strong) NSData *uncheckIconData;

@end

@interface TabBarConfig : BaseObject<NSCoding>
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSArray<TabBarConfigItem *> *tabVos;
@end

NS_ASSUME_NONNULL_END
