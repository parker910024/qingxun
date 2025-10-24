//
//  TTRoomKTVAlerView.h
//  TuTu
//
//  Created by zoey on 2018/11/19.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTRoomKTVAlerView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle attrMessage:(NSAttributedString *)attrMessage message:(NSString *)message backgroundMessage:(NSAttributedString *)backgroundMessage cancel:(void(^)(void))cancel ensure:(void(^)(void))ensure;
    
@end
