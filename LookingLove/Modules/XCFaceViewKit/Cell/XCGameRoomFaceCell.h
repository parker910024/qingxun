//
//  XCGameRoomFaceCell.h
//  XChat
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCGameRoomFaceCell : UICollectionViewCell

/**
 表情图标
 */
@property (strong, nonatomic) UIImageView *faceImageView;

/**
 表情名
 */
@property (strong, nonatomic) UILabel *faceName;

/**
 贵族标识 tag
 */
@property (strong, nonatomic) UIImageView *nobleTagImageView;

@end
