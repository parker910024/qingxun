//
//  TTWKGameOverView.h
//  TTPlay
//
//  Created by new on 2019/2/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol TTWKGameOverViewDelegate <NSObject>


- (void)againGameActionHander; // 再来一局

- (void)changGameActionHander; // 换个游戏

- (void)changePeopleActionHander; // 换个对手

- (void)backMainPageAciton; // 返回上一层

- (void)shareGameResultAction; // 分享
@end


NS_ASSUME_NONNULL_BEGIN

@interface TTWKGameOverView : UIView

@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, weak) id<TTWKGameOverViewDelegate> delegate;

@property (nonatomic, strong) NSString *superViewType;


@property (nonatomic, strong) UIButton *ageinGameButton;
@property (nonatomic, strong) UIButton *changeGameButton;
@property (nonatomic, strong) UIButton *changePeopleButton;
@property (nonatomic, strong) UIButton *backButton;

@end

NS_ASSUME_NONNULL_END
