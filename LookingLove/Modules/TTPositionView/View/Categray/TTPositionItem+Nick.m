//
//  TTPositionItem+Nick.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionItem+Nick.h"
//tool
#import "XCTheme.h"
#import "XCMacros.h"
#import "AuthCore.h"
#import "BaseAttrbutedStringHandler.h"
#import <YYText.h>
//core
#import "TTGameStaticTypeCore.h"
#import "ImRoomCoreV2.h"
#import "RoomQueueCoreV2.h"
//categray
#import "UIView+Gradient.h"
#import "UIImage+Utils.h"
#import "CALayer+QiNiu.h"
#import "UIButton+EnlargeTouchArea.h"



@implementation TTPositionItem (Nick)

- (void)setNickContent:(UserInfo *)userInfo position:(int)position {
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
        self.loveRoomNameButton.userInteractionEnabled = NO;
        [self.loveRoomNameButton setEnlargeEdgeWithTop:0 right:0 bottom:0 left:0];
        [self createNickString:position userInfo:userInfo];
        self.loveRoomNameButton.layer.cornerRadius = 7;
        self.loveRoomNameButton.layer.masksToBounds = YES;
    } else {
        if ([self.position isEqual:@"-1"]) {
            
            self.nickNameLabel.hidden = userInfo==nil? YES : NO;
            
            if (GetCore(RoomCoreV2).getCurrentRoomInfo.type == RoomType_CP) {
                self.nickNameLabel.hidden = NO;
            }
        }
        
        self.nickNameLabel.attributedText = [self createNickAttributeString];
    }
}

//create mic+nick+gender
- (NSMutableAttributedString *)createNickAttributeString{
    CGFloat fontSize = 0.0;
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.type == RoomType_CP) {
        fontSize = 10.0;
    }else{
        fontSize = ([self.position isEqual:@"-1"] ? 13.0 : 10.0);
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    //mic
    NSMutableAttributedString *micLabelString = [self createMicLabel:[NSString stringWithFormat:@"%d",self.position.intValue+1]];
    //nick
    NSMutableAttributedString *nickLabelString;
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode &&
        [self.position isEqualToString:@"-1"]) {
        // 离开模式
        nickLabelString = [self createNickLabel:GetCore(ImRoomCoreV2).roomOwnerInfo fontSize:fontSize];
    } else {
        nickLabelString = [self createNickLabel:self.sequence.userInfo fontSize:fontSize];
    }
    //gender
    NSMutableAttributedString *genderString = [self createGenderAttr];
    
    // 101认证标签 OR 官方主播认证标签
    NSMutableAttributedString *tagString = [self createTagAttrWithInfo:self.sequence.userInfo];
    
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.type == RoomType_CP) {
        [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
        [attributedString appendAttributedString:nickLabelString];
    } else {
        
        if ([self.position isEqual:@"-1"]) {
            BOOL isTT = YES;
            NSMutableAttributedString *firstAttr = isTT ? genderString : nickLabelString;
            
            switch (projectType()) {
                case ProjectType_LookingLove:
                case ProjectType_CeEr:
                {
                    //官方主播认证，不用验证房主位必须是房主
                    firstAttr = isTT ? (tagString ? tagString : firstAttr) : firstAttr;
                }
                    break;
                    
                default:
                {
                    //101，房主位必须是房主，大头位是房主
                    if (self.sequence.userInfo.uid == GetCore(RoomCoreV2).getCurrentRoomInfo.uid) {
                        firstAttr = isTT ? (tagString ? tagString : firstAttr) : firstAttr;
                    }
                }
                    break;
            }
            
            NSMutableAttributedString *lastAttr = isTT ? nickLabelString : genderString;
            NSAttributedString *combineAttr = [[NSAttributedString alloc] initWithString:@" "];
            
            [attributedString appendAttributedString:firstAttr];
            [attributedString appendAttributedString:combineAttr];
            [attributedString appendAttributedString:lastAttr];
        } else {
            
            [attributedString appendAttributedString:micLabelString];
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [attributedString appendAttributedString:nickLabelString];
        }
    }
    return attributedString;
}

//create mic
- (NSMutableAttributedString *)createMicLabel:(NSString *)text{
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:10];
    textLabel.bounds = CGRectMake(0, 0, 14, 14);
    textLabel.layer.masksToBounds = YES;
    textLabel.layer.cornerRadius = 7.0f;
    textLabel.text = text;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = UIColorRGBAlpha(0xffffff, 0.5);

    //麦序上有人，且在[非PK模式]下，才更改麦序的性别颜色
    //因为PK模式下，红蓝阵营和性别颜色有冲突
    if (self.sequence.userInfo) {
        if (self.sequence.userInfo.gender==UserInfo_Male) {
            textLabel.backgroundColor = UIColorRGBAlpha(0x3EBBFE, 1);
        }else{
            textLabel.backgroundColor = UIColorRGBAlpha(0xFF5E83, 1);
        }
        textLabel.textColor = UIColorRGBAlpha(0xffffff, 1);
    }else{
        
        textLabel.backgroundColor = UIColorRGBAlpha(0xffffff, 0.1);
    }
    
    NSMutableAttributedString * labelString = [NSMutableAttributedString yy_attachmentStringWithContent:textLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(textLabel.frame.size.width, textLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:10] alignment:YYTextVerticalAlignmentCenter];
    return labelString;
}

//create nick
- (NSMutableAttributedString *)createNickLabel:(UserInfo *)userInfo fontSize:(CGFloat)fontSize{
    
    UILabel *nickLabel = [[UILabel alloc]init];
    
    //text
    NSString *nick = userInfo.nick.length == 0 ? @"号麦位" : userInfo.nick;
    
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
        nick = userInfo.nick.length == 0 ? nick = @"未上麦" : userInfo.nick;
    }
    
    nickLabel.text = nick;
    nickLabel.font = [UIFont systemFontOfSize:fontSize];
    
    //color
    if (userInfo.nick.length){
        nickLabel.textColor = UIColorRGBAlpha(0xffffff, 1.0);
    }else{
        nickLabel.textColor = UIColorRGBAlpha(0xffffff, 0.6);
    }
    
    //width
    CGFloat nickWidth = [self sizeWithText:nick font:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(KScreenWidth , KScreenHeight)].width;
    // nickName 最大宽度 = 屏幕宽度 - 2 * (金蛋宽度 + 金蛋的 offseth) - offset
    CGFloat mainNickNameWidth = KScreenWidth - 2 * (63 + 14) - 10;
    //因为铭牌，将名称限制更短的长度
    if (projectType()==ProjectType_LookingLove ||
        projectType()==ProjectType_CeEr) {
        mainNickNameWidth = 110;
    }
    
    CGFloat maxWidth = [self.position isEqual:@"-1"] ? mainNickNameWidth : 70;
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.type == RoomType_CP) {
        maxWidth = 150;
    }
    if (nickWidth > maxWidth) {
        nickLabel.bounds = CGRectMake(0, 0, maxWidth, 14);
    }else {
        nickLabel.bounds = CGRectMake(0, 0, nickWidth+6, 14);
    }
    
    NSMutableAttributedString * nickString = [NSMutableAttributedString yy_attachmentStringWithContent:nickLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nickLabel.frame.size.width, nickLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:fontSize] alignment:YYTextVerticalAlignmentCenter];
    return nickString;
}


//create gender
- (NSMutableAttributedString *)createGenderAttr{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.bounds = CGRectMake(0, 0, 13, 13);;
    imageView.contentMode = UIViewContentModeScaleToFill;
    NSString *imageName = @"";
    if (self.sequence.userInfo.gender == 1) {
        imageName = [[XCTheme defaultTheme] common_sex_male];
    }else{
        imageName = [[XCTheme defaultTheme] common_sex_female];
    }
    imageView.image = [UIImage imageNamed:imageName];
    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return imageString;
}

- (NSMutableAttributedString *)createTagAttrWithInfo:(UserInfo *)info {
    
    switch (projectType()) {
        case ProjectType_LookingLove:
        case ProjectType_CeEr:
        {
            //官方主播认证
            if (info.nameplate && info.nameplate.fixedWord.length > 0) {
                NSMutableAttributedString *cert = [BaseAttrbutedStringHandler certificationTagWithName:info.nameplate.fixedWord image:info.nameplate.iconPic];
                return cert;
            }
        }
            break;
            
        default:
        {
            //101
            if (info.userInfoSkillVo.liveTag) {
                if (info.userInfoSkillVo.skillTag.length > 0) {
                    NSMutableAttributedString *tagTitleString = [self makeExperImage:info.userInfoSkillVo.skillTag size:CGSizeMake(50, 15)];
                    return tagTitleString;
                }
            }
        }
            break;
    }
    
    return nil;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (NSMutableAttributedString *)makeExperImage:(NSString *)experUrl size:(CGSize)size {
    
    CALayer *experLayer = [[CALayer alloc]init];
    experLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    experLayer.contentsGravity = kCAGravityResize;
    experLayer.contentsScale = [UIScreen mainScreen].scale;
    [experLayer qn_setImageImageWithUrl:experUrl placeholderImage:nil type:ImageTypeUserLibary];
    
    NSMutableAttributedString * experImageString = [NSMutableAttributedString yy_attachmentStringWithContent:experLayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(experLayer.frame.size.width, experLayer.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return experImageString;
}

- (void)createNickString:(NSInteger)position userInfo:(UserInfo *)userInfo {
    CGFloat fontSize = 10.0;
    
    NSString *nick;
    
    [self.loveRoomNameButton setTitleColor:UIColorRGBAlpha(0xffffff, 1) forState:UIControlStateNormal];
    //color
    if (userInfo.nick.length){
        self.loveRoomNameButton.alpha = 1;
    } else{
        self.loveRoomNameButton.alpha = 0.5;
    }
    
    // 如果我在-2麦 或者不在麦上。返回YES
    BOOL isMeOnHostMic = [self isMeOnMicOrNoMic];
    NSLog(@"%@",GetCore(ImRoomCoreV2).currentRoomInfo);
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.procedure == BlindDateProcedure_selectLove) { // 心动选择中
        if (position == -1) {
            nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick.length == 0 ? @"未上座" : userInfo.nick];
            [self createBlackNickLabelBackGroundImage];
        } else {
            if (userInfo.uid == GetCore(AuthCore).getUid.userIDValue) { // 此时麦上的人是我自己
                nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick];
                [self nickLabelBackGroundImage:position];
            } else {
                if (userInfo) {
                    if ([userInfo.blindDate.guests containsObject:@(GetCore(AuthCore).getUid.userIDValue)]) { // 当前是我在麦上。并且当前麦位上并不是我自己。获取选择当前麦位用户的人中是否有我
                        nick = [NSString stringWithFormat:@"%d.我的心动",(self.position.intValue + 1)];
                        [self createMyChooseLove];
                    } else {
                        if (isMeOnHostMic) {
                            nick = [self selectingLovePositionTypeNormal:userInfo];
                        } else {
                            if (!self.myUserInfo.blindDate.chooseMic) { // 我没有选择
                                nick = [NSString stringWithFormat:@"%d.选为心动",(self.position.intValue + 1)];
                                [self createChooseLovePerson];
                            } else {
                                nick = [self selectingLovePositionTypeNormal:userInfo];
                            }
                        }
                    }
                } else {
                    nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick.length == 0 ? @"未上座" : userInfo.nick];
                    [self nickLabelBackGroundImage:position];
                }
            }
        }
    } else if (GetCore(ImRoomCoreV2).currentRoomInfo.procedure == BlindDateProcedure_selectLoveTimerEnd) { // 心动选择倒计时结束
        if (position == -1) {
            nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick.length == 0 ? @"未上座" : userInfo.nick];
            [self createBlackNickLabelBackGroundImage];
        } else {
            if (userInfo.uid == GetCore(AuthCore).getUid.userIDValue) { // 此时麦上的人是我自己
                nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick];
                [self nickLabelBackGroundImage:position];
            } else {
                if (userInfo) {
                    if ([userInfo.blindDate.guests containsObject:@(GetCore(AuthCore).getUid.userIDValue)]) { // 当前是我在麦上。并且当前麦位上并不是我自己。获取选择当前麦位用户的人中是否有我
                        nick = [NSString stringWithFormat:@"%d.我的心动",(self.position.intValue + 1)];
                        [self createMyChooseLove];
                    } else {
                        if (!userInfo.blindDate.chooseMic) {
                            nick = [NSString stringWithFormat:@"%d.未选",(self.position.intValue + 1)];
                            [self createBlackNickLabelBackGroundImage];
                        } else {
                            nick = [NSString stringWithFormat:@"%d.已选",(self.position.intValue + 1)];
                            [self createBlackNickLabelBackGroundImage];
                        }
                    }
                } else {
                    nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick.length == 0 ? @"未上座" : userInfo.nick];
                    [self nickLabelBackGroundImage:position];
                }
            }
        }
    } else if (GetCore(ImRoomCoreV2).currentRoomInfo.procedure == BlindDateProcedure_publicLove) {
        if (position == -1) {
            nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick.length == 0 ? @"未上座" : userInfo.nick];
            [self createBlackNickLabelBackGroundImage];
        } else {
            if (userInfo) {
                if (userInfo.blindDate.chooseMic) {
                    if (userInfo.blindDate.publish) {
                        nick = [NSString stringWithFormat:@"%d.心动%d号",(self.position.intValue + 1),userInfo.blindDate.chooseMic.intValue + 1];
                        [self nickLabelBackGroundImage:position];
                    } else {
                        if ([self isMeOnHostMicAndMeIsActorOrManager]) {
                            nick = [NSString stringWithFormat:@"%d.公布心动",(self.position.intValue + 1)];
                            [self createChooseLovePerson];
                        } else {
                            if ([userInfo.blindDate.guests containsObject:@(GetCore(AuthCore).getUid.userIDValue)]) { // 当前是我在麦上。并且当前麦位上并不是我自己。获取选择当前麦位用户的人中是否有我
                                if ([self isMeOnMic]) {
                                    nick = [NSString stringWithFormat:@"%d.我的心动",(self.position.intValue + 1)];
                                    [self createMyChooseLove];
                                } else {
                                    nick = [NSString stringWithFormat:@"%d.未公布",(self.position.intValue + 1)];
                                    [self createBlackNickLabelBackGroundImage];
                                }
                            } else {
                                if (userInfo.uid == GetCore(AuthCore).getUid.userIDValue) { // 此时麦上的人是我自己
                                    nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick];
                                    [self nickLabelBackGroundImage:position];
                                } else {
                                    nick = [NSString stringWithFormat:@"%d.未公布",(self.position.intValue + 1)];
                                    [self createBlackNickLabelBackGroundImage];
                                }
                            }
                        }
                    }
                } else {
                    if (userInfo.uid == GetCore(AuthCore).getUid.userIDValue) { // 此时麦上的人是我自己
                        nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick];
                        [self nickLabelBackGroundImage:position];
                    } else {
                        if ([userInfo.blindDate.guests containsObject:@(GetCore(AuthCore).getUid.userIDValue)]) { // 当前是我在麦上。并且当前麦位上并不是我自己。获取选择当前麦位用户的人中是否有我
                            nick = [NSString stringWithFormat:@"%d.我的心动",(self.position.intValue + 1)];
                            [self createMyChooseLove];
                        } else {
                            nick = [NSString stringWithFormat:@"%d.未选",(self.position.intValue + 1)];
                            [self createBlackNickLabelBackGroundImage];
                        }
                    }
                }
            } else {
                nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick.length == 0 ? @"未上座" : userInfo.nick];
                [self nickLabelBackGroundImage:position];
            }
        }
    } else if (GetCore(ImRoomCoreV2).currentRoomInfo.procedure == BlindDateProcedure_resetIndroduce) {
        if (position == -1) {
            nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick.length == 0 ? @"未上座" : userInfo.nick];
            [self createBlackNickLabelBackGroundImage];
        } else {
            if (userInfo.uid == GetCore(AuthCore).getUid.userIDValue) { // 此时麦上的人是我自己
                nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick];
                [self nickLabelBackGroundImage:position];
            }  else {
                if (userInfo) {
                    if (userInfo.blindDate.chooseMic) {
                        if (userInfo.blindDate.publish) {
                            nick = [NSString stringWithFormat:@"%d.心动%d号",(self.position.intValue + 1),userInfo.blindDate.chooseMic.intValue + 1];
                            [self nickLabelBackGroundImage:position];
                        }
                    } else {
                        if (userInfo.uid == GetCore(AuthCore).getUid.userIDValue) { // 此时麦上的人是我自己
                            nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick];
                            [self nickLabelBackGroundImage:position];
                        } else {
                            nick = [NSString stringWithFormat:@"%d.未选",(self.position.intValue + 1)];
                            [self createBlackNickLabelBackGroundImage];
                        }
                    }
                } else {
                    nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick.length == 0 ? @"未上座" : userInfo.nick];
                    [self nickLabelBackGroundImage:position];
                }
            }
        }
    } else {
        nick = [NSString stringWithFormat:@"%d.%@",(self.position.intValue + 1),userInfo.nick.length == 0 ? @"未上座" : userInfo.nick];
        
        NSInteger i = position;
        if (i == -1) {
            [self createBlackNickLabelBackGroundImage];
        } else {
            [self nickLabelBackGroundImage:position];
        }
    }
    
    [self.loveRoomNameButton setTitle:nick forState:UIControlStateNormal];
    self.loveRoomNameButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (NSString *)selectingLovePositionTypeNormal:(UserInfo *)userInfo {
    if (!userInfo.blindDate.chooseMic) {
        [self nickLabelBackGroundImage:self.position.integerValue];
        return [NSString stringWithFormat:@"%d.选择中",(self.position.intValue + 1)];
    }
    
    [self createBlackNickLabelBackGroundImage];
    return [NSString stringWithFormat:@"%d.已选",(self.position.intValue + 1)];
}

- (void)nickLabelBackGroundImage:(NSInteger)position {
    if (position == 0 || position == 1 || position == 2 || position == 3) {
        [self.loveRoomNameButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFF71EA),UIColorFromRGB(0xFF4B90)] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(58, 14)] forState:UIControlStateNormal];
    } else if (position == 4 || position == 5 || position == 6 || position == 7) {
        [self.loveRoomNameButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[UIColorFromRGB(0x3A96FF),UIColorFromRGB(0x583EFF)] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(58, 14)] forState:UIControlStateNormal];
    }
}

// 黑色背景
- (void)createBlackNickLabelBackGroundImage {
    [self.loveRoomNameButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x000000)] forState:UIControlStateNormal];
}

// 创建我的心动
- (void)createMyChooseLove {
    [self.loveRoomNameButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFFD003),UIColorFromRGB(0xFFD457)] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(58, 14)] forState:UIControlStateNormal];
    [self.loveRoomNameButton setTitleColor:UIColorRGBAlpha(0x000000, 1) forState:UIControlStateNormal];
}

// 创建公布心动和选择心动
- (void)createChooseLovePerson {
    [self.loveRoomNameButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFFD003),UIColorFromRGB(0xFFD457)] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(58, 14)] forState:UIControlStateNormal];
    self.loveRoomNameButton.userInteractionEnabled = YES;
    [self.loveRoomNameButton setEnlargeEdgeWithTop:10 right:0 bottom:0 left:0];
    [self.loveRoomNameButton setTitleColor:UIColorRGBAlpha(0x000000, 1) forState:UIControlStateNormal];
}

// 我是否在麦上
- (BOOL)isMeOnMic {
    return [GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue];
}

//  如果我在-1麦 或者不在麦上。返回YES
- (BOOL)isMeOnMicOrNoMic {
    return [GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(AuthCore).getUid.userIDValue].intValue == -1  || ![GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue];
}

//  如果我在-1麦 返回YES
- (BOOL)isMeOnHostMic {
    return [GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(AuthCore).getUid.userIDValue].intValue == -1;
}

//  如果我在-1麦 并且我是（房主或者管理员，有操作权限） 返回YES
- (BOOL)isMeOnHostMicAndMeIsActorOrManager {
    return [self isMeOnHostMic] && ((GetCore(RoomQueueCoreV2).myMember.type == NIMChatroomMemberTypeCreator) || (GetCore(RoomQueueCoreV2).myMember.type == NIMChatroomMemberTypeManager));
}

@end
