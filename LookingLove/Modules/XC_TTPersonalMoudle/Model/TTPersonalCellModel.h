//
//  TTPersonalCellModel.h
//  TTPlay
//
//  Created by lee on 2019/3/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTPersonalSelctBlock)(void);

@interface TTPersonalCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) TTPersonalSelctBlock selectBlock;
@property (nonatomic, assign) UIRectCorner cornerType;

/**
 cell 上数据的模型

 @param title 标题
 @param detailText 副标题
 @param imageName 图片昵称
 @param selectBlock 点击回调
 @return 模型数据
 */
+ (TTPersonalCellModel *)normalModelWtiTitle:(NSString *)title
                                      detail:(NSString *)detailText
                                   imageName:(NSString *)imageName
                                 selectBlock:(TTPersonalSelctBlock)selectBlock;

/**
 cell 上数据的模型
 
 @param title 标题
 @param detailText 副标题
 @param imageName 图片昵称
 @param cornerType 切圆角的类型
 @param selectBlock 点击回调
 @return 模型数据
 */
+ (TTPersonalCellModel *)normalModelWtiTitle:(NSString *)title
                                      detail:(NSString *)detailText
                                   imageName:(NSString *)imageName
                                  cornerType:(UIRectCorner)cornerType
                                 selectBlock:(TTPersonalSelctBlock)selectBlock;
@end

NS_ASSUME_NONNULL_END
