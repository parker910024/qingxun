//
//  TTSearchVisitRoomCell.h
//  XC_TTHomeMoudle
//
//  Created by lvjunhang on 2020/3/2.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  进房记录

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomVisitRecord;

@interface TTSearchVisitRoomCell : UITableViewCell
@property (nonatomic, strong) NSArray<RoomVisitRecord *> *dataArray;
@property (nonatomic, copy) void (^selectedRoomHandler)(RoomVisitRecord *room);//选择房间
@property (nonatomic, copy) void (^cleanRecordHandler)(void);//清空记录
@end

@interface TTSearchVisitRoomCollectionCell : UICollectionViewCell
@property (nonatomic, strong) RoomVisitRecord *model;
@end

NS_ASSUME_NONNULL_END
