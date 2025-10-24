//
//  TTSearchCustomNavView.h
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSearchCustomNavView : UIView
/** 搜索框 */
@property (nonatomic, strong, readonly) UITextField *searchTextField;
/** 取消按钮 */
@property (nonatomic, strong, readonly) UIButton *cancleButton;
@end
