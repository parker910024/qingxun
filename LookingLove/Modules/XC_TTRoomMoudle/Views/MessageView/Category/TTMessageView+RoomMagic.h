//
//  TTMessageView+RoomMagic.h
//  TuTu
//
//  Created by KevinWang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView.h"

@interface TTMessageView (RoomMagic)

- (void)handleRoomMagicCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model;

@end
