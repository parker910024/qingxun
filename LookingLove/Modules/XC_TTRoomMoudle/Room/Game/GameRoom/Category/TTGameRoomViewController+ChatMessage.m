//
//  TTGameRoomViewController+ChatMessage.m
//  TTPlay
//
//  Created by Jenkins on 2019/3/7.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+ChatMessage.h"
#import "TTGameRoomViewController+FunctionMenu.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCCurrentVCStackManager.h"

@implementation TTGameRoomViewController (ChatMessage)

- (void)showRoomChatMessage{
    [self showRoomChatMessageWith:nil];
}

- (void)showRoomChatMessageWith:(UIViewController *)controller{
    if (controller) {
        if (self.messageVc) {
            [self.messageVc removeFromParentViewController];
        }
        self.messageVc = [[XCMediator sharedInstance] ttMessageMoudle_TTRoomMessageViewController];
        CGFloat height = 400;
        if (KScreenWidth > 320) {
            height = 530;
        }
       self.messageVc.view.frame = CGRectMake(0, KScreenHeight -height, KScreenWidth, height);
        self.messageVc.view.tag = 10000;
        UIView *backView = [[UIView alloc] initWithFrame:controller.view.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roomChatMessageViewRecognizer:)];
        [backView addGestureRecognizer:tap];
        
        [controller.view addSubview:backView];
        [controller.view addSubview:self.messageVc.view];
        [controller addChildViewController:self.messageVc];
    }else{
        [self updateFunctionMenu];
        if (self.messageVc) {
            [self.messageVc removeFromParentViewController];
        }
        
        self.messageVc = [[XCMediator sharedInstance] ttMessageMoudle_TTRoomMessageViewController];
        CGFloat height = 400;
        if (KScreenWidth > 320) {
            height = 530;
        }
        self.messageVc.view.frame = CGRectMake(0, KScreenHeight -height, KScreenWidth, height);
        self.messageVc.view.tag = 10000;
        [self addChildViewController:self.messageVc];
        
        self.roomContainerView.hidden = NO;
        [self.view bringSubviewToFront:self.roomContainerView];
        [self.roomContainerView addSubview:self.messageVc.view];
    }
}


/** 找人私聊*/
- (void)roomChatGotoUserWith:(UserID)uid{
    [self showRoomChatMessageWith:nil];
    
    [self performSelector:@selector(gotoSessionViewController:) withObject:@(uid) afterDelay:0.2];
}


- (void)roomChatGotoUserWith:(UserID)uid controller:(UIViewController *)controller{
    [self showRoomChatMessageWith:controller];
    
    [self performSelector:@selector(gotoSessionViewController:) withObject:@(uid) afterDelay:0.2];
}

- (void)gotoSessionViewController:(NSString *)uid{
    if (uid && uid.integerValue > 0) {
        UIViewController * sessionVC = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:uid.userIDValue sessectionType:NIMSessionTypeP2P];
        [sessionVC setValue:@(YES) forKey:@"isRoomMessage"];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.messageVc.view.layer addAnimation:transition forKey:nil];
        [self.messageVc addChildViewController:sessionVC];
        [self.messageVc.view addSubview:sessionVC.view];
    }
}

- (void)onRecvAnMsg:(NIMMessage *)msg{
    if (![self.roomContainerView.subviews containsObject:self.messageVc.view]) {
        if (msg.session.sessionType !=  NIMSessionTypeChatroom) {
            [self updateFunctionMenu];
        }
    }
}

- (void)roomChatMessageViewRecognizer:(UITapGestureRecognizer *)tap{
    UIView * view = tap.view;
    [view removeFromSuperview];
    
    [self chatRoomHiddenWhenTouchView];
}

- (void)chatRoomHiddenWhenTouchView{
    
    if (self.messageVc.view && self.messageVc.view.subviews.count >0) {
        for (UIView * subView in self.messageVc.view.subviews) {
            [subView removeFromSuperview];
        }
    }
    
    if (self.messageVc.view && self.messageVc.childViewControllers.count > 0) {
        for (UIViewController * controller in self.messageVc.childViewControllers) {
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
        }
    }
    
    if (self.messageVc) {
        [self.messageVc removeFromParentViewController];
        [self.messageVc.view removeFromSuperview];
        self.messageVc = nil;
    }
    
    if (![self.roomContainerView.subviews containsObject:self.messageVc.view]) {
        [self updateFunctionMenu];
    }
}

@end
