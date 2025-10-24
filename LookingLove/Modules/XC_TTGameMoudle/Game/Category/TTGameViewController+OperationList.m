//
//  TTGameViewController+OperationList.m
//  TTPlay
//
//  Created by new on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameViewController+OperationList.h"
#import "NSArray+Safe.h"
@implementation TTGameViewController (OperationList)

- (NSInteger )returnCellNumberRowsIfSection:(TTGameHomeModuleModel *)model{
    NSMutableArray *listArray = model.data.mutableCopy;
    NSInteger bigCell = 0;
    NSInteger smallRooms = 0;
    if (model.maxNum > listArray.count) {
        if (listArray.count % 3 == 0) {
            bigCell = listArray.count / 3;
        }else{
            bigCell = listArray.count / 3 + 1;
        }
        smallRooms = 0;
    }else{
        if (model.maxNum % 3 == 0) {
            bigCell = model.maxNum / 3;
        }else{
            bigCell = model.maxNum / 3 + 1;
        }
        smallRooms = (listArray.count - model.maxNum) > model.listNum ? model.listNum : (listArray.count - model.maxNum);
    }
    
    return bigCell + smallRooms;
}

- (NSInteger )returnBigCellNumberRowsIfSection:(TTGameHomeModuleModel *)model{
    NSMutableArray *listArray = model.data.mutableCopy;
    NSInteger bigCell = 0;
    if (model.maxNum > listArray.count) {
        if (listArray.count % 3 == 0) {
            bigCell = listArray.count / 3;
        }else{
            bigCell = listArray.count / 3 + 1;
        }
    }else{
        if (model.maxNum % 3 == 0) {
            bigCell = model.maxNum / 3;
        }else{
            bigCell = model.maxNum / 3 + 1;
        }
    }
    return bigCell;
}

- (CGFloat )returnOperationSectionHeaderHeight:(NSInteger )modelCount{
    
    NSInteger bigCellRows = modelCount;
    CGFloat heightRow = 0;
    for ( int i = 0; i < bigCellRows; i++) {
        if (i == 0) {
            heightRow = 45;
        }else{
            heightRow = heightRow + 37;
        }
    }
    return heightRow;
}

- (NSArray<TTHomeV4DetailData *> *)bigRoomsFromDatas:(NSArray<TTHomeV4DetailData *> *)datas bigRoomCount:(NSUInteger)count WithBigMaxNum:(NSInteger )maxNum WithCellNumber:(NSInteger )bigCellNumber{
    
    NSMutableArray<TTHomeV4DetailData *> *dataArray = [NSMutableArray array];
    if (datas.count > 0) {
        if (datas.count >= maxNum) {
            for (int i = count; i < bigCellNumber; i++) {
                if (i < bigCellNumber - 1) {
                    for ( int j = i * 3; j < 3 * (i + 1); j++ ) {
                        if ([datas safeObjectAtIndex:j]) {
                            [dataArray addObject:[datas safeObjectAtIndex:j]];
                        }
                    }
                    break;
                }else{
                    for (int m = i * 3; m < maxNum; m++) {
                        if ([datas safeObjectAtIndex:m]) {
                            [dataArray addObject:[datas safeObjectAtIndex:m]];
                        }
                    }
                    break;
                }
            }
            return dataArray;
        }else{
            for (int i = count; i < bigCellNumber; i++) {
                if (i < bigCellNumber - 1) {
                    for ( int j = i * 3; j < 3 * (i + 1); j++ ) {
                        if ([datas safeObjectAtIndex:j]) {
                            [dataArray addObject:[datas safeObjectAtIndex:j]];
                        }
                    }
                    break;
                }else{
                    for (int m = i * 3; m < datas.count; m++) {
                        if ([datas safeObjectAtIndex:m]) {
                            [dataArray addObject:[datas safeObjectAtIndex:m]];
                        }
                    }
                    break;
                }
            }
            return dataArray;
        }
    }else{
        return dataArray;
    }
}


//  2 * 2 返回的 cell 行数
- (NSInteger )returnCellNumberWithOtherModelIfSection:(TTGameHomeModuleModel *)model {
    if (model.data.count % 2 == 0) {
        return model.data.count / 2;
    } else {
        return model.data.count / 2 + 1;
    }
}

//  2 * 2 返回的 cell 行数
- (NSInteger )returnCellNumberWithLineHeigtIfSection:(TTGameHomeModuleModel *)model {
    if (model.data.count % 2 == 0) {
        if (model.data.count / 2 > 1) {
            return (model.data.count / 2 - 1) * 20;
        } else {
            return 0;
        }
    } else {
        if (model.data.count / 2 + 1 > 1) {
            return (model.data.count / 2) * 20;
        } else {
            return 0;
        }
    }
}

@end
