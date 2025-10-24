//
//  TTDisplayModelMaker+Red.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/18.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTDisplayModelMaker+Red.h"

#import "XCRedRecieveAttachment.h"
#import "XCRedDrawAttachment.h"

#import "TTStatisticsService.h"

@implementation TTDisplayModelMaker (Red)

- (TTMessageDisplayModel *)makeRedWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model {
    
    if (!model) {
        model = [[TTMessageDisplayModel alloc] init];
        model.message = message;
    }
    
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)obj.attachment;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];

    if (attachment.first == Custom_Noti_Header_Red) {
        if (attachment.second == Custom_Noti_Sub_Red_Room_Current) {
            [str appendAttributedString:[self currentRedAttributedString:(XCRedRecieveAttachment *)attachment model:model]];
        } else if (attachment.second == Custom_Noti_Sub_Red_Room_Other) {
            [str appendAttributedString:[self otherRedAttributedString:(XCRedRecieveAttachment *)attachment model:model]];
        } else if (attachment.second == Custom_Noti_Sub_Red_Room_Draw) {
            [str appendAttributedString:[self drawRedAttributedString:(XCRedDrawAttachment *)attachment model:model]];
        }
    }
        
    str.yy_lineSpacing = 6;

    model.content = str;
    model.contentHeight = [[TTMessageViewLayout shareLayout] getAttributedHeightWith:str];
    
    return model;
}

/// 当前房间的红包公屏显示
- (NSMutableAttributedString *)currentRedAttributedString:(XCRedRecieveAttachment *)attach model:(TTMessageDisplayModel *)model {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str yy_appendString:attach.nick];
    [str yy_appendString:@"发了一个"];
    [str appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 22, 22) urlString:nil imageName:@"room_red_screen_ico"]];
    [str yy_appendString:@"将在"];
    [str yy_appendString:attach.startTime];
    [str yy_appendString:@"开启！"];
    [str yy_appendString:[NSString stringWithFormat:@"“%@”", attach.notifyText]];
    
    str.yy_font = [UIFont systemFontOfSize:12];
    str.yy_color = UIColor.whiteColor;
    
    [str yy_setColor:UIColorFromRGB(0xFFD98C) range:[str.string rangeOfString:attach.startTime]];
    
    [str yy_setTextHighlightRange:[str.string rangeOfString:attach.nick] color:UIColorFromRGB(0xFFD98C) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
//        if (model.textDidClick) {
//            model.textDidClick(attach.uid);
//        }
    }];
    
    return str;
}

/// 其他房间的红包公屏显示
- (NSMutableAttributedString *)otherRedAttributedString:(XCRedRecieveAttachment *)attach model:(TTMessageDisplayModel *)model {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str yy_appendString:attach.nick];
    [str yy_appendString:@" 在"];
    NSRange titleRange = NSMakeRange(str.length, attach.title.length);
    [str yy_appendString:attach.title];
    [str yy_appendString:@"发了一个"];
    [str appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 22, 22) urlString:nil imageName:@"room_red_screen_ico"]];
    [str yy_appendString:[NSString stringWithFormat:@"“%@”", attach.notifyText]];
    NSRange tapMeRange = NSMakeRange(str.length, 2);
    [str yy_appendString:@"点我"];
    [str yy_appendString:@" 带你去抢红包>"];
    
    str.yy_font = [UIFont systemFontOfSize:12];
    str.yy_color = UIColor.whiteColor;
    
    [str yy_setUnderlineStyle:NSUnderlineStyleSingle range:tapMeRange];
    [str yy_setColor:UIColorFromRGB(0xFF5B4A) range:tapMeRange];
    [str yy_setColor:UIColorFromRGB(0xFFD98C) range:titleRange];

    [str yy_setTextHighlightRange:NSMakeRange(0, str.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        if (model.textDidClick) {
            model.textDidClick(attach.roomUid);
        }
    }];
    
    return str;
}

/// 抢到红包
- (NSMutableAttributedString *)drawRedAttributedString:(XCRedDrawAttachment *)attach model:(TTMessageDisplayModel *)model {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str yy_appendString:@"恭喜"];
    [str yy_appendString:attach.recvUserNick];
    [str yy_appendString:@"抢到了"];
    NSString *coin = [NSString stringWithFormat:@" %@金币", attach.amount];
    [str yy_appendString:coin];
    [str yy_appendString:@"，感谢 "];
    [str yy_appendString:attach.sendUserNick];
    [str yy_appendString:@"老板的红包"];
    
    str.yy_font = [UIFont systemFontOfSize:12];
    str.yy_color = UIColor.whiteColor;
    
    [str yy_setColor:UIColorFromRGB(0xFFD98C) range:[str.string rangeOfString:coin]];
    [str yy_setColor:UIColorFromRGB(0xFFD98C) range:NSMakeRange(str.length-2, 2)];
    
    [str yy_setTextHighlightRange:[str.string rangeOfString:attach.recvUserNick] color:UIColorFromRGB(0xFFD98C) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {

    }];
    
    return str;
}

@end

