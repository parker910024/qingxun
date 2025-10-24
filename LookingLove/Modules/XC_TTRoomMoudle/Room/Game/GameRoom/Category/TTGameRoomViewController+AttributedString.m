//
//  TTGameRoomViewController+AttributedString.m
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+AttributedString.h"

#import <YYText.h>
#import "XCMacros.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "RoomCoreV2.h"

static NSString *k_room_label_font = @"font";
static NSString *k_room_label_color = @"color";
static NSString *k_room_label_maxWidth = @"maxWidth";

@implementation TTGameRoomViewController (AttributedString)

//创建房间title/lock/effect/高音质
- (NSMutableAttributedString *)creatRoomTitle:(NSString *)roomTitle{
    
    if (roomTitle == nil) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    
    UIFont *font =  [UIFont systemFontOfSize:15];
    NSDictionary *titleDictAttr = @{ NSForegroundColorAttributeName:[UIColor whiteColor],
                                     NSFontAttributeName: font,
                                     };
    NSAttributedString *titleAttr = [[NSAttributedString alloc] initWithString:roomTitle attributes:titleDictAttr];
    [attributedString appendAttributedString:titleAttr];
    
    return attributedString;
}

- (NSMutableAttributedString *)creatRoomLock_GiftEffect_HighAudio:(RoomInfo *)roomInfo{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    UIFont *font =  [UIFont systemFontOfSize:15];
    
    // lock
    if (roomInfo.roomPwd.length && ![roomInfo.roomPwd isEqual:@" "]) {
        [attributedString appendAttributedString:[self createAttachmentString:@"tt_room_lock_logo" font:font]];
    }

    if (GetCore(RoomCoreV2).hasChangeGiftEffectControl) {
//            GetCore(ImRoomCoreV2).currentRoomInfo.hasAnimationEffect = GetCore(RoomCoreV2).hasAnimationEffect;
        if (!GetCore(RoomCoreV2).hasAnimationEffect) {
            [attributedString appendAttributedString:[self createAttachmentString:@"room_toolbar_more_gifteffect_topClose" font:font]];
        }
    } else {
        // GiftEffect
        if (!roomInfo.hasAnimationEffect) {
            [attributedString appendAttributedString:[self createAttachmentString:@"room_toolbar_more_gifteffect_topClose" font:font]];
        }
    }

    // AudioQulity
    if (roomInfo.audioQuality == AudioQualityType_High) {
        [attributedString appendAttributedString:[self createAttachmentString:@"room_audio_high_quality" font:font]];
    }
    
    return attributedString;
}


- (NSMutableAttributedString *)createAttachmentString: (NSString *)imageUrl font:(UIFont *)font {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];

    // 空格
    NSAttributedString *placeholderAttr = [[NSAttributedString alloc] initWithString:@" "];
    
    NSTextAttachment *roomLockAttachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:imageUrl];
    roomLockAttachment.image = image;
    CGRect bounds = CGRectMake(0, roundf(font.capHeight - 13)/2.f - 1, 13, 13);
    roomLockAttachment.bounds = bounds;
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:roomLockAttachment];
    [attributedString appendAttributedString:placeholderAttr];
    [attributedString appendAttributedString:imageAttr];
    return attributedString;
}


//靓/id/在线人数
- (NSMutableAttributedString *)creatRoomBeauty_ID:(UserInfo *)userInfo onLineCount:(int)count{

    NSMutableAttributedString *idString = [[NSMutableAttributedString alloc] init];
    
    if (userInfo.hasPrettyErbanNo) {
        
        NSMutableAttributedString * beautyString = [self makeImageAttributedString:CGRectMake(0, -3, 10, 10) urlString:nil imageName:@"common_beauty"];
        [idString appendAttributedString:beautyString];
        [idString appendAttributedString:[self creatStrAttrByStr:@" "]];
    }
    //ID
    [idString appendAttributedString:[self creatStrAttrByStr:[NSString stringWithFormat:@"ID%@",userInfo.erbanNo] attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorRGBAlpha(0xffffff, 0.5)}]];
    
    //online count
    [idString appendAttributedString:[self creatStrAttrByStr:@"   "]];
    NSMutableAttributedString *onlineString = [self creatStrAttrByStr:[NSString stringWithFormat:@"%d人在线>",count] attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorRGBAlpha(0xffffff, 0.5)}];
    [idString appendAttributedString:onlineString];
    
    return idString;
}


//根据图片资源创建图片富文本
- (NSMutableAttributedString *)makeImageAttributedString:(CGRect)frame urlString:(NSString *)urlString imageName:(NSString *)imageName{
    UIImageView *charmImageView = [[UIImageView alloc]init];
    charmImageView.bounds = frame;
    charmImageView.contentMode = UIViewContentModeScaleToFill;
    if (urlString.length>0) {
        [charmImageView qn_setImageImageWithUrl:urlString placeholderImage:nil type:ImageTypeUserLibary];
    }else{
        charmImageView.image = [UIImage imageNamed:imageName];
    }
    NSMutableAttributedString * charmImageString = [NSMutableAttributedString yy_attachmentStringWithContent:charmImageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(charmImageView.frame.size.width, charmImageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return charmImageString;
}


//LabelAttr
- (NSMutableAttributedString *)makeLabelAttr:(NSString *)title labelAttribute:(NSDictionary *)attribute{
    if (title == 0) {
        title = @" ";
    }
    CGFloat nickWidth = [self sizeWithText:title font:attribute[k_room_label_font] maxSize:CGSizeMake(KScreenWidth, KScreenHeight)].width;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.numberOfLines = 1;
    label.hidden = NO;
    label.font = attribute[k_room_label_font];
    label.textColor = attribute[k_room_label_color];
    CGFloat maxWidth = [attribute[k_room_label_maxWidth] floatValue];
    if (nickWidth > maxWidth) {
        label.bounds = CGRectMake(0, 0, maxWidth, 15);
    }else {
        label.bounds = CGRectMake(0, 0, nickWidth+0.5, 15+2);
    }
    
    NSMutableAttributedString * nickString = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(label.frame.size.width, label.frame.size.height) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return nickString;
}

- (NSMutableAttributedString *)creatStrAttrByStr:(NSString *)str {
    
    return [self creatStrAttrByStr:str attributed:nil];
}

- (NSMutableAttributedString *)creatStrAttrByStr:(NSString *)str attributed:(NSDictionary *)attribute{
    if (str.length == 0 || !str) {
        str = @" ";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str attributes:attribute];
    return attr;
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
