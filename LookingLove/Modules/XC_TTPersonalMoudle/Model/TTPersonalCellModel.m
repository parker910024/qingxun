//
//  TTPersonalCellModel.m
//  TTPlay
//
//  Created by lee on 2019/3/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPersonalCellModel.h"

@implementation TTPersonalCellModel

+ (TTPersonalCellModel *)normalModelWtiTitle:(NSString *)title detail:(NSString *)detailText imageName:(NSString *)imageName selectBlock:(TTPersonalSelctBlock)selectBlock {
    TTPersonalCellModel *model = [[TTPersonalCellModel alloc] init];
    model.title = title;
    model.detail = detailText;
    model.imageName = imageName;
    model.selectBlock = selectBlock;
    return model;
}

+ (TTPersonalCellModel *)normalModelWtiTitle:(NSString *)title detail:(NSString *)detailText imageName:(NSString *)imageName cornerType:(UIRectCorner)cornerType selectBlock:(TTPersonalSelctBlock)selectBlock {
    TTPersonalCellModel *model = [[TTPersonalCellModel alloc] init];
    model.title = title;
    model.detail = detailText;
    model.imageName = imageName;
    model.selectBlock = selectBlock;
    model.cornerType = cornerType;
    return model;
}

@end
