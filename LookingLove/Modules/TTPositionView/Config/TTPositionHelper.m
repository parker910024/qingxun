//
//  TTPositionHelper.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionHelper.h"
//categray
#import "UIImageView+QiNiu.h"
#import "UIImage+Utils.h"
//tool
#import "XCTheme.h"
#import <YYText.h>
//core
#import "NobleCore.h"
#import "RoomCoreV2.h"
#import "ImRoomCoreV2.h"

static TTPositionHelper * helper;

@implementation TTPositionHelper

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[TTPositionHelper alloc] init];
    });
    return helper;
}

+ (void)handlerImageView:(UIImageView *)imageView  soure:(id)source imageType:(ImageType)imageType{
    
    if (imageType == ImageTypeRoomChatBuble) {
        if ([source isKindOfClass:[NSURL class]]) {
            
        }else if ([source isKindOfClass:[UIImage class]]){
            UIImage *image = (UIImage *)source;
            UIImage *newImage = [self handleBubbleImage:image];
            imageView.image = newImage;
        }else if ([source isKindOfClass:[NSString class]]){
            UIImage *image = [GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source];
            UIImage *newImage = [self handleBubbleImage:image];
            imageView.image = newImage;
        }
        
        return;
    }
    
    
    if ([source isKindOfClass:[NSURL class]]) {
        [imageView qn_setImageImageWithUrl:[(NSURL *)source absoluteString] placeholderImage:nil type:imageType];
    }else if ([source isKindOfClass:[UIImage class]]){
        imageView.image = (UIImage *)source;
    }else if ([source isKindOfClass:[NSString class]]){
        UIImage *image = [GetCore(NobleCore) findNobleSourceBySourceId:(NSString *)source];
        imageView.image = image;
    }else if ([source isKindOfClass:[UIColor class]]){
        imageView.image = [UIImage imageWithColor:(UIColor *)source];
    }
}

+ (UIImage *)handleBubbleImage:(UIImage *)image {
    //适配文字只有一行到时候，cell被imageview撑大。
    CGFloat top = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat right = image.size.width * 0.5;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImageResizingMode mode = UIImageResizingModeStretch;
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    return  newImage;
}

//tutu topic
- (NSMutableAttributedString *)createTuTuTopicAtttibutedStringWith:(TTPositionTopicModel *)model {
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    //tag
    if (!model.roomTag.length) {
        model.roomTag = @"聊天";
    }
    NSMutableAttributedString * tagLabelString = [self makeLabelAttr:model.roomTag cornerRadius:2];
    [attributedString appendAttributedString:tagLabelString];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    //topic
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:model.topicString attributes:@{NSForegroundColorAttributeName:UIColorRGBAlpha(0xffffff, 0.5),NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    if (model.isEdit) {
        //edit
        NSMutableAttributedString * editImageString = [self makeImageAttributedString:CGRectMake(0, 0, 12, 12) urlString:nil imageName:@"room_game_position_edit"];
        [attributedString appendAttributedString:editImageString];
    }
    
    return attributedString;
}

//erban topic
- (NSMutableAttributedString *)makeLabelAttr:(NSString *)title cornerRadius:(CGFloat)cornerRadius {
    if (title == 0) {
        title = @" ";
    }
    CGFloat width = [self sizeWithText:title font:[UIFont systemFontOfSize:10.0] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    label.hidden = NO;
    if (projectType() == ProjectType_CeEr || projectType() == ProjectType_LookingLove) {
        label.font = [UIFont systemFontOfSize:9.0];
        label.textColor = XCTheme.getTTMainColor;
        label.backgroundColor = UIColorRGBAlpha(0x000000,  0.2);
        label.layer.cornerRadius = 4;
    } else {
        label.font = [UIFont systemFontOfSize:10.0];
        label.textColor = UIColorFromRGB(0xffffff);
        label.backgroundColor = UIColorRGBAlpha(0xFFFFFF,  0.16);
        label.layer.cornerRadius = cornerRadius;
        label.layer.borderWidth = 0;
        label.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    }
    label.layer.masksToBounds = YES;
    CGFloat maxWidth = 50.0;
    if (width > maxWidth) {
        label.bounds = CGRectMake(0, 0, maxWidth, 10+2);
    }else {
        label.bounds = CGRectMake(0, 0, width+8, 10+2);
    }
    NSMutableAttributedString * nickString = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(label.frame.size.width, label.frame.size.height) alignToFont:[UIFont systemFontOfSize:10] alignment:YYTextVerticalAlignmentCenter];
    return nickString;
}

//根据图片资源创建图片富文本
- (NSMutableAttributedString *)makeImageAttributedString:(CGRect)frame urlString:(NSString *)urlString imageName:(NSString *)imageName {
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

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/** 是不是显示土豪位*/
- (BOOL)showTTPositionVipViewWith:(TTRoomPositionViewLayoutStyle)style {
    if (style == TTRoomPositionViewLayoutStyleNormal) {
        RoomInfo * info = GetCore(RoomCoreV2).getCurrentRoomInfo;
        ChatRoomMicSequence * queue = [GetCore(ImRoomCoreV2).micQueue objectForKey:[NSString stringWithFormat:@"%d", 7]];
        if (queue.microState.posState == MicroPosStateFree && queue.userInfo == nil) {
            if (info.isPermitRoom == PermitRoomType_Licnese || info.isPermitRoom == PermitRoomType_YoungerStar) {
                return YES;
            }
        }
    }
    return NO;
}

/** 根据布局的形式得到是什么房间的类型*/
- (TTRoomPositionViewType)configTTRoomPositionViewType:(TTRoomPositionViewLayoutStyle)style {
    //KTV 房主离线 PK 礼物值 CP CPgame  普通模式
    TTRoomPositionViewType positionType;
    RoomInfo * info = GetCore(RoomCoreV2).getCurrentRoomInfo;
    if (style == TTRoomPositionViewLayoutStyleCP) {
        if (info.isOpenGame) {
            positionType = TTRoomPositionViewTypeCPGame;
        } else {
            positionType = TTRoomPositionViewTypeCP;
        }
    }else {
        //普通房离线模式
        if (info.leaveMode) {
            positionType = TTRoomPositionViewTypeOwnerLeave;
        }else {
            positionType = TTRoomPositionViewTypeNormal;
        }
    }
    return positionType;
}



@end
