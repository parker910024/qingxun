//
//  TTPickMicContentView.m
//  WanBan
//
//  Created by lvjunhang on 2020/10/13.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTPickMicContentView.h"
#import "TTPickMickPositionView.h"

#import "XCMacros.h"
#import "TTPopup.h"

#import "ImRoomCoreV2.h"
#import "RoomQueueCoreV2.h"

@interface TTPickMicContentView ()

@property (nonatomic, assign) UserID uid;
@property (nonatomic, assign) RoomType roomType;

@end

@implementation TTPickMicContentView

- (instancetype)initWithRoomType:(RoomType)roomType uid:(UserID)uid {
    self = [super init];
    if (self) {
        self.uid = uid;
        self.roomType = roomType;
        
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    
    CGFloat w = 44;
    CGFloat h = 44 + 30;
    CGFloat margin = 25;//边距
    CGFloat horiInterval = (KScreenWidth - 30*2 - margin*2 - w*4)/3.0;
    
    BOOL cpRoom = self.roomType == RoomType_CP;//CP房
    BOOL blindDateRoom = self.roomType == RoomType_Love; //相亲房
    BOOL normalRoom = self.roomType == RoomType_Game;  //普通房
    
    int nightPosFlag = (blindDateRoom || normalRoom) ? 1 : 0;//九麦位标志
    int posCount = cpRoom ? 2 : 9;
    
    for (int i = 0; i < posCount; i++) {
        
        int pos = i - 1;//麦序
        if (blindDateRoom) {
            pos = [self calculateBlindDatePos:pos];
        }
        ChatRoomMicSequence *micro = [GetCore(ImRoomCoreV2).micQueue objectForKey:@(pos).stringValue];
        
        CGFloat x = margin + (w+horiInterval) * ((i-nightPosFlag)%4);
        CGFloat originY = (blindDateRoom || normalRoom) ? 88 : margin;
        CGFloat y = originY + h * ((i-nightPosFlag)/4);
        
        if (pos == -1) {//房主位
            x = (KScreenWidth - 30 * 2 - w) / 2.0;
            y = 15;
        }
        
        int posNameIndex = i + 1 - nightPosFlag;//麦位序号名称
        if (blindDateRoom) {
            posNameIndex = [self calculateBlindDatePosNameIndex:posNameIndex];
        }
        
        NSString *posLabel = [NSString stringWithFormat:@"%d号麦", posNameIndex];//麦位名称
        if (cpRoom) {
            if (i == 0) {
                posLabel = @"房主位";
            } else {
                posLabel = @"1号麦";
            }
        }
        
        TTPickMickPositionView *view = [[TTPickMickPositionView alloc] init];
        view.frame = CGRectMake(x, y, w, h);
        [view postionLabel:posLabel];
        view.picked = micro.userInfo != nil;
        view.tag = pos;
        [view addTarget:self action:@selector(didClickPositionView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:view];
    }
}

- (void)didClickPositionView:(TTPickMickPositionView *)sender {
    if (sender.isPicked) {
        return;
    }
    
    NSString *pos = @(sender.tag).stringValue;
    [GetCore(RoomQueueCoreV2) inviteUpMic:self.uid postion:pos];
    
    [TTPopup dismiss];
}

/// 相亲房3、4麦位和5、6麦位麦序交换
/// @param pos 普通正常麦序
- (int)calculateBlindDatePos:(int)pos {
    if (pos==2) {pos = 4; return pos;}
    if (pos==3) {pos = 5; return pos;}
    if (pos==4) {pos = 2; return pos;}
    if (pos==5) {pos = 3; return pos;}
    
    return pos;
}

/// 相亲房3、4麦位和5、6麦位名称交换
/// @param posIndex 普通正常麦位名称
- (int)calculateBlindDatePosNameIndex:(int)posIndex {
    if (posIndex==3) {posIndex = 5; return posIndex;}
    if (posIndex==4) {posIndex = 6; return posIndex;}
    if (posIndex==5) {posIndex = 3; return posIndex;}
    if (posIndex==6) {posIndex = 4; return posIndex;}
    
    return posIndex;
}

@end
