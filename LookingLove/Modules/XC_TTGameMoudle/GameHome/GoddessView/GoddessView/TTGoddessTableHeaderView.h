//
//  TTGoddessTableHeaderView.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/3.
//  合拍女神的头部 - 大厅热聊

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTGoddessViewDelegate;
@class NIMMessageModel;

@interface TTGoddessTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) id<TTGoddessViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<NIMMessageModel *> *dataModelArray;

@end

NS_ASSUME_NONNULL_END
