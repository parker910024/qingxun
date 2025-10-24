//
//  TTDressUpContainHeadView.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfo,UserHeadWear;


@protocol TTDressUpContainHeadViewDelegate<NSObject>
- (void)onClickBackAction;
- (void)onClickMineDressupAction;
@end

@interface TTDressUpContainHeadView : UIView
@property (nonatomic, weak) id<TTDressUpContainHeadViewDelegate> delegate;//
@property (nonatomic, strong) UserInfo  *info;//
//@property (nonatomic, strong) UserHeadWear  *selectHeadwear;//
@property (nonatomic, assign) BOOL isShowBage; // 显示红色标点
@end
