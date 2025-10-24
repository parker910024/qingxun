//
//  TTMessageView+ArrangeMic.h
//  TuTu
//
//  Created by gzlx on 2018/12/18.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageView (ArrangeMic)
//房间开启排麦 房间关闭排麦 管理抱人上麦 设置为自由麦/排麦模式
- (void)handleArrangeMicCell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model;
@end

NS_ASSUME_NONNULL_END
