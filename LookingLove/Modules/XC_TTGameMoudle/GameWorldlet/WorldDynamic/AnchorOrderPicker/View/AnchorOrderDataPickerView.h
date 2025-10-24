//
//  AnchorOrderDataPickerView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/29.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  数据滚轮选择器

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnchorOrderDataPickerView : UIView

/**
 数据列表
 */
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, copy) NSString *selectData;

@property (nonatomic, copy) void(^selectHandler)(NSString *content);

- (void)showAlert;

@end

NS_ASSUME_NONNULL_END
