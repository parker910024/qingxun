//
//  TTPersonalSectionModel.m
//  TTPlay
//
//  Created by lee on 2019/3/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPersonalSectionModel.h"

@implementation TTPersonalSectionModel

+ (instancetype)normalModelWithHeadDesc:(NSString *)headDesc footDesc:(NSString *)footDesc sectionCellModelArray:(NSArray *)cellModelArray {
    TTPersonalSectionModel *sectionModel = [[TTPersonalSectionModel alloc]init];
    sectionModel.headDesc = headDesc;
    sectionModel.footDesc = footDesc;
    sectionModel.cellModelArray = cellModelArray;
    return sectionModel;
}

- (CGFloat)headerHeight {
    return [TTPersonalSectionModel heightWithString:self.headDesc];
}

- (CGFloat)footerHeight {
    return [TTPersonalSectionModel heightWithString:self.footDesc];
}

+ (CGFloat)heightWithString:(NSString *)string {
    return [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * KHeaderFooterLabelPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height + 15;
}

@end
