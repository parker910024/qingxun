//
//  PublicChatroomMessageHelper.m
//  AFNetworking
//
//  Created by 卫明 on 2018/11/1.
//

#import "PublicChatroomMessageHelper.h"
#import "Attachment.h"
#import "GiftAllMicroSendInfo.h"

#import "GCDHelper.h"

#import "BaseAttrbutedStringHandler.h"

//model
#import "TTTimestampModel.h"
//core
#import "AuthCore.h"
#import "UserCore.h"
#import "ImPublicChatroomCore.h"
//client
#import "TTPublicChatroomMessageProtocol.h"
//tool
#import "NIMInputEmoticonParser.h"
#import "NIMInputEmoticonManager.h"
#import "UIImage+NIMKit.h"
#import "TTPublicChatAttrbutedStringHandler.h"
#import "TTPublicChatDataHelper.h"
#import "NIMKitInfoFetchOption.h"
#import "NIMKit.h"
#import <YYText.h>
#import "TTPublicGameView.h"
//theme
#import "XCTheme.h"

//attach
#import "PublicChatAtMemberAttachment.h"
#import "TTGameCPPrivateChatModel.h"
#import "TTGameCPPrivateSysNotiModel.h"
#import "XCRedRecieveAttachment.h"

#import "XCMediator+TTRoomMoudleBridge.h"

#import "TTStatisticsService.h"

@interface PublicChatroomMessageHelper ()

@property (strong, nonatomic) dispatch_queue_t attrQueue;

@property (nonatomic,assign) NSTimeInterval showTimeInterval;

@end

@implementation PublicChatroomMessageHelper
//{
//    dispatch_queue_t attrQueue;
//}

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _attrQueue = dispatch_queue_create("com.tutu.attributedString", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


- (void)configAttrSyncWithMessage:(NIMMessage *)message andModel:(NIMMessageModel *)model {
    if ([message.session.sessionId integerValue] != GetCore(ImPublicChatroomCore).publicChatroomId) {
        return;
    }
    if (message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
        if (obj.attachment && [obj.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)obj.attachment;
            if (attachment.first == Custom_Noti_Header_PublicChatroom) {
                if ([model.message.from isEqualToString:[GetCore(AuthCore)getUid]]) {
                    model.bgName = @"message_public_chat_bubble_orange";
                }else {
                    model.bgName = @"message_public_chat_bubble_white";
                }
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
                switch (attachment.second) {
                    case Custom_Noti_Sub_PublicChatroom_Send_Gift:{
                        
                        GiftAllMicroSendInfo *info = [GiftAllMicroSendInfo yy_modelWithDictionary:attachment.data];
                        //                        //发送者名称
                        //                        NSMutableAttributedString *nick = [[NSMutableAttributedString alloc]initWithString:info.nick];
                        //                        [nick addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, nick.length)];
                        //                        [string appendAttributedString:nick];
                        //
                        //                        //空格
                        //                        [string appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];
                        //
                        //送
                        NSMutableAttributedString *give = [BaseAttrbutedStringHandler creatStrAttrByStr:@"赠送"];
                        [give addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, give.length)];
                        [string appendAttributedString:give];
                        
                        //空格
                        [string appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];
                        
                        //接受者名称
                        NSMutableAttributedString *receiveNick = [BaseAttrbutedStringHandler creatStrAttrByStr:info.targetNick];
                        [receiveNick addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, receiveNick.length)];
                        [string appendAttributedString:receiveNick];
                        
                        //空格
                        [string appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];
                        //礼物图片
                        [string appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 36, 36) urlString:info.giftInfo.giftUrl imageName:nil]];
                        //空格
                        [string appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:3]];
                        
                        //数量
                        NSMutableAttributedString *x = [BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"X%ld",(long)info.giftNum]];
                        [x addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, x.length)];
                        [string appendAttributedString:x];
                        if ([model.message.from isEqualToString:[GetCore(AuthCore)getUid]]) {
                            [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];
                        }else {
                            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
                        }
                    }
                        break;
                    case Custom_Noti_Sub_PublicChatroom_Send_At: {
                        PublicChatAtMemberAttachment *att = [PublicChatAtMemberAttachment modelDictionary:attachment.data];
                        [string appendAttributedString:[self disposeEmoji:att.content]];
                        
                        for (NSString *uid in att.atUids) {
                            NSString *baseNick = [att.atNames objectAtIndex:[att.atUids indexOfObject:uid]];
                            NSMutableString *searchNick = [baseNick mutableCopy];
                            //                            [searchNick appendString:@"\u2004"];
                            
                            
                            //ex:”@你好 “
                            NSMutableAttributedString *nick = [[NSMutableAttributedString alloc]initWithString:searchNick];
                            
                            [nick appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:@"\u2004"]]; //加空格
                            
                            NSRange range = [string.mutableString rangeOfString:searchNick options:(NSStringCompareOptions)NSCaseInsensitiveSearch];
                            //                            if ([message.from integerValue] == [[GetCore(AuthCore) getUid] integerValue]) {
                            //                                [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(0, string.length)];
                            //                            }else {
                            //                                [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x000000) range:NSMakeRange(0, string.length)];
                            //                            }
                            if ([uid integerValue] == [[GetCore(AuthCore) getUid] integerValue]) { //是@自己，需要变红
                                //找到我自己的文本在文本中的位置
                                
                                [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF3D56) range:range];
                                //自己的话是白色
                                if ([message.from integerValue] == [[GetCore(AuthCore) getUid] integerValue]) {
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(0, range.location)];
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(range.location + range.length, string.length - range.location - range.length)];
                                }else { //其他人是黑色
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x000000) range:NSMakeRange(0, range.location)];
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x000000) range:NSMakeRange(range.location + range.length, string.length - range.location - range.length)];
                                }
                            }else {
                                //自己的话是白色
                                if ([message.from integerValue] == [[GetCore(AuthCore) getUid] integerValue]) {
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:range];
                                    
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(0, range.location > string.length ? string.length : range.location)];
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(range.location <= string.length ? range.location + range.length : 0, range.location <= string.length ? string.length - range.location - range.length : string.length)];
                                    
                                }else { //其他人是黑色
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x000000) range:range];
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x000000) range:NSMakeRange(0, range.location > string.length ? string.length : range.location)];
                                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x000000) range:NSMakeRange(range.location <= string.length ? range.location + range.length : 0, range.location <= string.length ? string.length - range.location - range.length : string.length)];
                                }
                            }
                        }
                    }
                        break;
                    case Custom_Noti_Sub_PublicChatroom_Send_Broadcast: {
                        
                    }
                        break;
                    default:
                        break;
                }
                
                model.messageAttributedString = string;
                
            }else if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableAttributedString *gameString = [[NSMutableAttributedString alloc] init];
                    if (attachment.second == Custom_Noti_Sub_CPGAME_PrivateChat_LaunchGame) {
                        TTPublicGameView *gameView = [[TTPublicGameView alloc] initWithFrame:CGRectMake(0, 0, 180, 140)];
                        if (gameView) {
                            gameView.message = message;
                        }
                        gameString = [NSMutableAttributedString yy_attachmentStringWithContent:gameView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(gameView.frame.size.width, gameView.frame.size.height) alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];

                    }
                    model.messageAttributedString = gameString;
                });
            }else if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification){
                NSMutableAttributedString *gameString = [[NSMutableAttributedString alloc] init];
                if (attachment.second == Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_GameOver) {

                    TTGameCPPrivateSysNotiModel *model = [TTGameCPPrivateSysNotiModel modelDictionary:attachment.data];

                    gameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",model.msg] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    
                    gameString.yy_alignment = NSTextAlignmentCenter;
                    
                }
                model.messageAttributedString = gameString;
                
            }else if (attachment.first == Custom_Noti_Header_Red) {
                if (attachment.second == Custom_Noti_Sub_Red_Room_Other) {
                    
                    XCRedRecieveAttachment *attach;
                    if ([attachment isKindOfClass:[XCRedRecieveAttachment class]]) {
                        attach = (XCRedRecieveAttachment *)attachment;
                    } else {
                        //注意：接口请求的附件类型是Attachment
                        attach = [XCRedRecieveAttachment modelWithJSON:attachment.data];
                        attach.first = attachment.first;
                        attach.second = attachment.second;
                    }
                    
                    NSMutableAttributedString *str = [self receiveRedAttributedString:attach];
                    model.messageAttributedString = str;
                }
                
            }else{
                if ([model.message.from isEqualToString:[GetCore(AuthCore)getUid]]) {
                    model.bgName = @"message_public_chat_bubble_orange";
                }else {
                    model.bgName = @"message_public_chat_bubble_white";
                }
                
                NSMutableAttributedString *gameString = [[NSMutableAttributedString alloc] initWithString:@"新消息类型，请更新版本"];
                model.messageAttributedString = gameString;
            }
        }
    }else if (message.messageType == NIMMessageTypeText) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@""];
        
        [string appendAttributedString:[self disposeEmoji:message.text]];
        
        if ([model.message.from isEqualToString:[GetCore(AuthCore)getUid]]) {
            model.bgName = @"message_public_chat_bubble_orange";
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];
        }else {
            model.bgName = @"message_public_chat_bubble_white";
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
        }
        
        model.messageAttributedString = string;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //涉及到富文本生成【certificationTagWithName】，放到主线程执行
        model.nameAttributedString = [self disposeNameAttributedString:model];
    });
}

/// 收到红包
- (NSMutableAttributedString *)receiveRedAttributedString:(XCRedRecieveAttachment *)attach {
    
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
    [str yy_setColor:UIColorFromRGB(0xFF5B4A) range:titleRange];

    [str yy_setTextHighlightRange:NSMakeRange(0, str.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        [TTStatisticsService trackEvent:@"room_enter_red_paper_room" eventDescribe:@"公聊大厅"];
        
        //跳转到红包所在房间
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:attach.roomUid];
    }];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 12.0f;
    style.headIndent = 12.0f;
    style.tailIndent = -12.0f;
//    style.lineSpacing = 6;
    
    [str yy_setParagraphStyle:style range:NSMakeRange(0, str.length)];
    
    return str;
}

- (NSMutableAttributedString *)disposeNameAttributedString:(NIMMessageModel *)model {
    NIMMessage *message = model.message;
    
    SingleNobleInfo *nobleInfo = [TTPublicChatDataHelper disposeRoomExtToModel:message.remoteExt uid:message.from];
    LevelInfo *levelInfo = [TTPublicChatDataHelper disposeRoomExtToLevelModel:message.remoteExt uid:message.from];
    
    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
    option.message = message;
    NIMKitInfo *userinfo = [[NIMKit sharedKit].provider infoByUser:message.from option:option];
    
    UserInfo *info = [[UserInfo alloc]init];
    info.nick = userinfo.showName;
    info.nobleUsers = nobleInfo;
    info.userLevelVo = levelInfo;
    info.hasPrettyErbanNo = [TTPublicChatDataHelper disposeHasPrettyNo:message.remoteExt uid:message.from];
    info.defUser = [TTPublicChatDataHelper disposeAccountType:message.remoteExt uid:message.from];
    info.newUser = [TTPublicChatDataHelper disposeNewUserToLevelModel:message.remoteExt uid:message.from];
    info.nameplate = [TTPublicChatDataHelper disposeOfficialAnchorCertification:message.remoteExt uid:message.from];
    
    return [TTPublicChatAttrbutedStringHandler makePublicChatUserNameWithUserInfo:info];
}

- (NSMutableAttributedString *)disposeEmoji:(NSString *)string {
    NSMutableAttributedString *emojiStr = [[NSMutableAttributedString alloc]initWithString:@""];
    NSArray *tokens = [[NIMInputEmoticonParser currentParser]tokens:string];
    NSInteger index = 0;
    for (NIMInputTextToken *token in tokens) {
        if (token.type == NIMInputTokenTypeEmoticon) {
            NIMInputEmoticon *emotion = [[NIMInputEmoticonManager sharedManager]emoticonByTag:token.text];
            UIImage *image = [UIImage nim_emoticonInKit:emotion.filename];
            if (image) {
                
                NSMutableAttributedString *emoji = [TTPublicChatAttrbutedStringHandler makeEmojiAttributedString:image];
                [emojiStr appendAttributedString:emoji];
                
                emojiStr.yy_lineSpacing = 13;
            }
        }else {
            NSString *text = token.text;
            [emojiStr appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:text]];
        }
        index++;
    }
    return emojiStr;
    
}


#pragma mark - getter & setter

- (NSTimeInterval)showTimeInterval {
    return 300;
}

@end
