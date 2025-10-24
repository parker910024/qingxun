
//
//  TTGameMenuModel.m
//  AFNetworking
//
//  Created by lee on 2019/6/13.
//

#import "TTGameMenuModel.h"

@implementation TTGameMenuModel

+ (TTGameMenuModel *)normalModelWtiTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    TTGameMenuModel *model = [[TTGameMenuModel alloc] init];
    model.title = title;
    model.titleColor = titleColor;
    return model;
}

@end
