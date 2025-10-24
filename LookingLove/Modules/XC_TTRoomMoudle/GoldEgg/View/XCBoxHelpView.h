//
//  XCBoxHelpView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCBoxHelpView : UIView

/**
 是否是至尊金蛋
 */
@property (nonatomic, assign) BOOL isDiamondBox;

/**
 刷新帮助图片

 @param imageURL 图片地址
 */
- (void)updateImage:(NSString *)imageURL;

@end
