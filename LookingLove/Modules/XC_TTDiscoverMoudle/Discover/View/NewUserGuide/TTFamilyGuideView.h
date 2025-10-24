//
//  TTFamilyGuideView.h
//  TuTu
//
//  Created by gzlx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FamilyGuideType){
    FamilyGuideType_Share = 1,//分享
    FamilyGuideType_Manager = 2,//家族管理
    FamilyGuideType_Group = 3, //创建群
};

@interface TTFamilyGuideView : UIView

- (void)showInView:(UIView *)parentview maskView:(UIView *)view guideType:(FamilyGuideType)type dismiss:(void(^)(BOOL isShow))show;

- (void)showInView:(UIView *)view maskBtn:(nullable UIButton *)btn guideType:(FamilyGuideType)type dismiss:(void(^)(BOOL isShow))show;

@end

NS_ASSUME_NONNULL_END
