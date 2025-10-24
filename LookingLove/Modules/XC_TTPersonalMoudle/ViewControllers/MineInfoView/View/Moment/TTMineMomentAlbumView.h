//
//  TTMineMomentAlbumView.h
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/27.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  相册

#import <UIKit/UIKit.h>

#import "UserMoment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMineMomentAlbumView : UIView
///图片数组
@property (nonatomic, strong) NSArray<UserMomentRes *> *imageUrls;

@property (nonatomic, copy) void (^oneImageSuccess)(CGFloat height);

//得到图片的高度
+ (CGFloat)getPictureViewHeightWithImageInfoList:(NSArray<UserMomentRes *> *)imageList;

@end

NS_ASSUME_NONNULL_END
