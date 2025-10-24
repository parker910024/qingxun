//
//  TTSearchRecordCell.h
//  XC_TTHomeMoudle
//
//  Created by lvjunhang on 2020/3/2.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  搜索记录

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTSearchRecordCell : UITableViewCell
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void (^selectedRecordHandler)(NSString *record);//选择记录
@property (nonatomic, copy) void (^cleanRecordHandler)(void);//清空记录
@end

@interface TTSearchRecordCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
