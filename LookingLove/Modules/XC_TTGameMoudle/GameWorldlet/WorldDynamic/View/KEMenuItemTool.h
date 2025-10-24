//
//  KEMenuItemTool.h
//  LTChat
//
//  Created by apple on 2019/8/3.
//  Copyright © 2019 wujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, KEMenuItemToolType) {
    KEMenuItemToolTypeCopy = 0,           // 复制
    KEMenuItemToolTypeReport = 1,         // 举报
    KEMenuItemToolTypeDelete = 2,          //删除
};

static NSString *const kItemIconKey = @"icon";
static NSString *const kItemTextKey = @"text";
static NSString *const kItemTypeKey = @"type";

typedef void(^itemClcikActionBlock)(KEMenuItemToolType tagType);

@interface KEMenuItem : UIView

@property (nonatomic, copy) NSString *itemIcon;
@property (nonatomic, copy) NSString *itemText;
@property (nonatomic, copy) itemClcikActionBlock itemClickBlock;

- (instancetype)initWithFrame:(CGRect)frame iconName:(NSString *)iconName text:(NSString *)text;

@end

@interface KEMenuItemTool : UIView


/**
 举报或者 删除
 
 @param tagetBtn 参照的viw
 @param title BtnTitle
 @param completeBlock 成功回调
 */
- (void)showRightMoreButton:(UIButton *)tagetBtn title:(NSString *)title complete:(void(^)(void))completeBlock;
/**
 复制
 
 @param tagetView 参照的viw
 @param title BtnTitle
 @param completeBlock 成功回调
 */
- (void)showCenterMoreView:(UIView *)tagetView title:(NSString *)title complete:(void(^)(void))completeBlock;



/**
 举报和删除
 */
- (void)showMoreTypeView:(UIView *)tagetView title:(NSString *)title secondTitle:(NSString *)secondTitle complete:(void(^)(KEMenuItemToolType type))completeTypeBlock;

/**
 举报和删除和复制
 */
- (void)showMoreTypeView:(UIView *)tagetView actionNames:(NSArray<NSDictionary *> *)actionNames complete:(void(^)(KEMenuItemToolType type))completeTypeBlock;
@end

NS_ASSUME_NONNULL_END
