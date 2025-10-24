//
//  Target_TTHomeMoudle.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

// 搜索页面, 个人页装扮跳过来 zen送 按钮点击的回调 === 需要和个人模块商量的一致 == 参数为uid == nickName
typedef void(^TTSearchPresentDidClickBlock)(long long, NSString *);

@interface Target_TTHomeMoudle : NSObject

- (UIViewController *)Action_TTHomeViewController;

- (UIViewController *)Action_TTHomeFamilyViewController;

- (UIViewController *)Action_TTSearchRoomViewController:(NSDictionary *)dict;
@end
