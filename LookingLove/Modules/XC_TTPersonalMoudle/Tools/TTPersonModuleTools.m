//
//  TTPersonModuleTools.m
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonModuleTools.h"

//model
#import "DressUpModel.h"

//t
#import "XCTheme.h"

@implementation TTPersonModuleTools

+ (NSString *)getNameFromDressUpLimitType:(DressUpModel *)model {
    NSString *imageName;
    switch (model.labelType) {
        case DressUpLabelType_Not:
            imageName = @"";
            break;
        case DressUpLabelType_New:
            imageName = @"person_DressUp_New";
            break;
        case DressUpLabelType_Discount:
            imageName = @"person_DressUp_Discount";
            break;
        case DressUpLabelType_Limit:
            imageName = @"person_DressUp_Limit";
            break;
        case DressUpLabelType_Exclusive:
            imageName = @"person_DressUp_Exclusive";
            break;
        default:
            imageName = @"";
            break;
    }
    return imageName;
}

+ (NSAttributedString *)getPriceAttriButeStringWithPrice:(NSString *)price {
    NSString *priceString = [NSString stringWithFormat:@"%@金币",price];
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[XCTheme getTTDeepGrayTextColor]}];
    [aString addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMainColor] range:NSMakeRange(0, price.length)];
    return aString.copy;
}

@end
