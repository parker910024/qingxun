//
//  XCEmptyDataView.h
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCEmptyDataView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, strong) UIColor *color;

/** image */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
/** 图片和文字之间的间距(可正可负) 默认18 */
@property (nonatomic, assign) CGFloat margin;
@end
