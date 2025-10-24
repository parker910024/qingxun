//
//  TTPersonalSectionModel.h
//  TTPlay
//
//  Created by lee on 2019/3/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPersonalCellModel.h"
NS_ASSUME_NONNULL_BEGIN
static CGFloat const KHeaderFooterLabelPadding = 20;

@interface TTPersonalSectionModel : NSObject
@property (nonatomic, copy) NSString *headDesc;
@property (nonatomic, copy) NSString *footDesc;
@property (nonatomic, strong) NSArray <TTPersonalCellModel *> *cellModelArray;

// normal
+ (instancetype)normalModelWithHeadDesc:(NSString *)headDesc
                               footDesc:(NSString *)footDesc
                  sectionCellModelArray:(NSArray *)cellModelArray;

- (CGFloat)headerHeight;

- (CGFloat)footerHeight;

+ (CGFloat)heightWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
