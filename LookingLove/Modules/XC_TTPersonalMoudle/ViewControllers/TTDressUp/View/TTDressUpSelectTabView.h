//
//  TTDressUpSelectTabView.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TTDressUpSelectTabView : UIView

@property (nonatomic, assign) int index;//
@property (nonatomic, copy) void (^selectBlock)(int selectIndex);//

- (instancetype)initWithFrame:(CGRect)frame  titles:(NSArray *)titles;


@end
