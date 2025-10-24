//
//  TTGameRoomViewController+Game.h
//  TuTu
//
//  Created by zoey on 2018/12/10.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"
#import "FaceCoreClient.h"

@interface TTGameRoomViewController (Game)<FaceCoreClient>

- (void)onClickGameStartBtn:(UIButton *)btn;
- (void)onClickGameOpenBtn:(UIButton *)btn;
- (void)onClickGameCancelBtn:(UIButton *)btn;

@end
