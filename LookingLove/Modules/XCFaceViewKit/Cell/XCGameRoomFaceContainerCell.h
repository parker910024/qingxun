//
//  XCGameRoomFaceContainerCell.h
//  XChat
//
//  Created by 卫明何 on 2017/12/12.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceConfigInfo;
@protocol XCFaceViewKitDelegate;

@interface XCGameRoomFaceContainerCell : UICollectionViewCell

/**
 单页collectionview
 */
@property (strong, nonatomic) UICollectionView *collectionView;

/**
 单页表情数据
 */
@property (strong, nonatomic) NSMutableArray<FaceConfigInfo *> *faceInfos;

@property (nonatomic, weak) id<XCFaceViewKitDelegate> delegate;
@end
