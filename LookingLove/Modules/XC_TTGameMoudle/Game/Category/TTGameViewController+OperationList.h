//
//  TTGameViewController+OperationList.h
//  TTPlay
//
//  Created by new on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameViewController (OperationList)

- (NSInteger )returnCellNumberRowsIfSection:(TTGameHomeModuleModel *)model;

- (NSInteger )returnBigCellNumberRowsIfSection:(TTGameHomeModuleModel *)model;

- (CGFloat )returnOperationSectionHeaderHeight:(NSInteger )modelCount;
//- (NSArray<TTHomeV4DetailData *> *)bigRoomsFromDatas:(NSArray<TTHomeV4DetailData *> *)datas bigRoomCount:(NSUInteger)count;

- (NSArray<TTHomeV4DetailData *> *)bigRoomsFromDatas:(NSArray<TTHomeV4DetailData *> *)datas bigRoomCount:(NSUInteger)count WithBigMaxNum:(NSInteger )maxNum WithCellNumber:(NSInteger )bigCellNumber;
//- (TTHomeV4DetailData *)smallRoomDataForIndexPath:(NSIndexPath *)indexPath;


//  2 * 2 返回的 cell 行数
- (NSInteger )returnCellNumberWithOtherModelIfSection:(TTGameHomeModuleModel *)model;

- (NSInteger )returnCellNumberWithLineHeigtIfSection:(TTGameHomeModuleModel *)model;
@end

NS_ASSUME_NONNULL_END
