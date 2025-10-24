//
//  TTUserCardContainerView.h
//  TuTu
//
//  Created by 卫明 on 2018/11/15.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserCore.h"

#import "TTUserCardFunctionItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    ShowUserCardType_Online,//在线列表
    ShowUserCardType_Rank//榜单
}ShowUserCardType;

typedef void(^TapFunctionItemBlock)(UserID uid);

@interface TTUserCardContainerView : UIView

/**
 初始化方法

 @param frame 大小
 @param uid uid
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame uid:(UserID)uid;


/**
 初始化方法
 点击榜单 点击在线列表
 @param frame 大小
 @param uid uid
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame uid:(UserID)uid type:(ShowUserCardType)type;

/**
 中部的操作按钮 不传即中间的不见了
 */
@property (strong, nonatomic) NSMutableArray<TTUserCardFunctionItem *> *functionArray;

/**
 底部的操作按钮 不传即下面的不见了
 */
@property (strong, nonatomic) NSMutableArray<TTUserCardFunctionItem *> *bottomOpeArray;

/** 得到这个View的高度*/
+ (CGFloat)getTTUserCardContainerViewHeightWithFunctionArray:(NSMutableArray *)functionArray bottomOpeArray:(NSMutableArray *)bottomOpeArray;

/**
给view赋值
 */
- (void)setTTUserCardContainerViewHeightWithFunctionArray:(NSMutableArray * __nullable)functionArray bottomOpeArray:(NSMutableArray *__nullable)bottomOpeArray;;

@property (nonatomic, copy) TapFunctionItemBlock itemBlock;

@end

NS_ASSUME_NONNULL_END
