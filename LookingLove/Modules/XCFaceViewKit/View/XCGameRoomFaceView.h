//
//  XCGameRoomFaceView.h
//  XChat
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 XC. All rights reserved.
//
//  发送表情view

#import <UIKit/UIKit.h>

//displaymodel
#import "XCGameRoomFaceViewDisplayModel.h"


@protocol XCFaceViewKitDelegate;

@interface XCGameRoomFaceView : UIView

@property (nonatomic, weak) id<XCFaceViewKitDelegate> delegate;

/**
 分组的表情数组
 */
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *faceInfos;

/**
 表情collection
 */
@property (strong, nonatomic) UICollectionView *faceCollectionView;

/**
 初始化方法，必须调用这个

 @param frame 大小
 @param displayMode 展示模型
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame WithDisplayModel:(XCGameRoomFaceViewDisplayModel *)displayMode;

@end
