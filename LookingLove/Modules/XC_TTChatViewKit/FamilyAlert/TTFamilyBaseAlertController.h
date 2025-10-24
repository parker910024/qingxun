//
//  TTFamilyBaseAlertController.h
//  TuTu
//
//  Created by gzlx on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCAlertControllerCenter.h"
#import "TTFamilyAlertModel.h"
#import "XCFamily.h"
#import "GroupModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ActionBlock)(void);
typedef void(^TextBlock)(NSString *text);

@protocol TTFamilyBaseAlertControllerDelegate <NSObject>
- (void)imagePickerControllerdidFinishPickingMediaWithInfo:(UIImage *)selectImage;
@end

@interface TTFamilyBaseAlertController : XCAlertControllerCenter

@property (nonatomic, strong) XCFamily * family;
@property (nonatomic, strong) GroupModel * group;
+ (instancetype)defaultCenter;
/** 只展示文字没有输入框*/
- (void)showAlertViewWith:(UIViewController *)controller alertConfig:(TTFamilyAlertModel *)config sure:(ActionBlock)sureBlock canle:(nullable ActionBlock)cancleBlcok;

/** 有输入框*/
- (void)showAlertViewWithTextFiledWith:(UIViewController *)controller alertConfig:(TTFamilyAlertModel *)config sure:(ActionBlock)sureBlock canle:(nullable ActionBlock)cancleBlcok text:(TextBlock)textBlock;

/** 族长邀请好友的弹框*/
- (void)showShareAlertViewWith:(UIViewController *)controller alertConfig:(TTFamilyAlertModel *)config sure:(ActionBlock)sureBlock canle:(nullable ActionBlock)cancleBlcok;

/** 谈起分享框*/
- (void)shareAppcationActionSheetWith:(UIViewController *)controller;

/** 选择图片弹框*/
- (void)showChoosePhotoWith:(UIViewController *)controller delegate:(id<TTFamilyBaseAlertControllerDelegate>)delegate;

/** 弹框消失*/
- (void)dismissAlert;

@end

NS_ASSUME_NONNULL_END
