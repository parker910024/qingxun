//
//  XCShareView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/9/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCShareItem.h"

typedef enum : NSUInteger {
    XCShareViewStyleCenter,
    XCShareViewStyleCenterAndBottom,
    XCShareViewStyleAll,
} XCShareViewStyle;

@class XCShareView;
@protocol XCShareViewDelegate <NSObject>

- (void)shareView:(XCShareView *)shareView didSelected:(XCShareItemTag)itemTag;
- (void)shareViewDidClickCancle:(XCShareView *)shareView;

@end;

@interface XCShareView : UIView

@property (nonatomic, weak) id<XCShareViewDelegate> delegate;

- (instancetype)initWithItemSize:(CGSize)itemSize items:(NSArray<XCShareItem *> *)items margin:(CGFloat)margin;
/**
 初始化XCShareView
 
 @param itemSize 每个分享item的大小
 @param items    分享的item数据源
 @param edgeInsets 分享item距离容器的上下左右间距
 @return XCShareView
 */
- (instancetype)initWithShareViewStyle:(XCShareViewStyle)style items:(NSArray<XCShareItem *> *)items itemSize:(CGSize)itemSize edgeInsets:(UIEdgeInsets)edgeInsets ;

@end
