//
//  MessageBoardFilter.m
//  XCChatCoreKit
//
//  Created by 卫明 on 2019/1/24.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "MessageBoardFilter.h"

@implementation MessageBoardFilter

+ (instancetype)shareFilter {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 是否支持的信息, 仅适用房间公屏
 
 @param message 云信消息实体
 @return 是否支持
 */
+ (BOOL)isSupportMsg:(NIMMessage *)message {
    NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        return [[[MessageBoardFilter getFilterDataSource] objectForKey:@(attachment.first)] containsObject:@(attachment.second)];
    }
    return NO;
}

+ (NSDictionary *)getFilterDataSource { // 目前仅兼容TuTu(义锟)
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = @{
                     @(Custom_Noti_Header_Room_Tip):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Header_Room_Tip_ShareRoom),
                          @(Custom_Noti_Header_Room_Tip_Attentent_Owner),
                          nil],
                     @(Custom_Noti_Header_ALLMicroSend):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_AllMicroSend),
                          @(Custom_Noti_Sub_AllMicroLuckySend),
                          @(Custom_Noti_Sub_AllBatchSend),
                          nil],
                     @(Custom_Noti_Header_Segment_AllMicSend):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_Segment_AllMicSend_LuckBag),
                          nil],
//                     @(Custom_Noti_Header_NobleNotify):
//                         [NSSet setWithObjects:
//                          @(Custom_Noti_Sub_NobleNotify_Open_Success),
//                          @(Custom_Noti_Sub_NobleNotify_Renew_Success),
//                          nil],
                     @(Custom_Noti_Header_Queue):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_Queue_Kick),
                          @(Custom_Noti_Sub_Queue_Invite),
                          nil],
                     @(Custom_Noti_Header_Kick):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_Kick_BeKicked),
                          @(Custom_Noti_Sub_Kick_BlackList),
                          nil],
//                     @(Custom_Noti_Header_Game):
//                         [NSSet setWithObjects:
//                          @(Custom_Noti_Sub_Game_Start),
//                          @(Custom_Noti_Sub_Game_Result),
//                          nil],
                     @(Custom_Noti_Header_Update_RoomInfo):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_Update_RoomInfo_AgoraAudioQuity),
                          @(Custom_Noti_Sub_Update_RoomInfo_AnimateEffect),
                          @(Custom_Noti_Sub_Update_RoomInfo_MessageState),
                          @(Custom_Noti_Sub_Update_RoomInfo_Notice),
                          nil],
                     @(Custom_Noti_Header_Dragon):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_Dragon_Finish),
                          @(Custom_Noti_Sub_Dragon_Cancel),
                          @(Custom_Noti_Sub_Dragon_Continue),
                          nil],
                     @(Custom_Noti_Header_Box):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_Box_Me),
                          @(Custom_Noti_Sub_Box_InRoom),
                          @(Custom_Noti_Sub_Box_AllRoom),
                          @(Custom_Noti_Sub_Box_AllRoom_Notify),
//                          @(Custom_Noti_Sub_Box_InRoom_AllMicSend),
                          nil],
                     @(Custom_Noti_Header_ArrangeMic):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Header_ArrangeMic_Mode_Open),
                          @(Custom_Noti_Header_ArrangeMic_Mode_Close),
                          @(Custom_Noti_Header_ArrangeMic_Free_Mic_Open),
                          @(Custom_Noti_Header_ArrangeMic_Free_Mic_Close),
                          nil],
                     @(Custom_Noti_Header_CPGAME):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_CPGAME_Select),
//                          @(Custom_Noti_Sub_CPGAME_Prepare),
                          @(Custom_Noti_Sub_CPGAME_Start),
                          @(Custom_Noti_Sub_CPGAME_End),
                          @(Custom_Noti_Sub_CPGAME_Cancel_Prepare),
                          @(Custom_Noti_Sub_CPGAME_Open),
                          @(Custom_Noti_Sub_CPGAME_Close),
                          @(Custom_Noti_Sub_CPGAME_Ai_Enter),
                          @(Custom_Noti_Sub_CPGAME_RoomGame),
                          nil],
                     @(Custom_Noti_Header_Gift):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_Gift_Send),
                          nil],
                     @(Custom_Noti_Header_RoomMagic):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_Magic_Send),
                          @(Custom_Noti_Sub_AllMicro_MagicSend),
                          @(Custom_Noti_Sub_Batch_MagicSend),
                          nil],
                     @(Custom_Noti_Header_CPGAME_PrivateChat):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_CPGAME_PrivateChat_LaunchGame),
                          nil],
                     @(Custom_Noti_Header_Checkin):
                         [NSSet setWithObjects:
                          @(Custom_Noti_Sub_Checkin_Draw_second_coin),
                          nil],
                     @(Custom_Noti_Header_Game_LittleWorld): [NSSet setWithObjects:@(Custom_Noti_Sub_Little_World_Room_Lead_Notify),@(Custom_Noti_Sub_Little_World_Room_Join_Notify),@(Custom_Noti_Sub_Little_World_Room_Praise_Notify), nil],
                     
                     @(Custom_Noti_Header_Room_SuperAdmin): [NSSet setWithObjects:@(Custom_Noti_Sub_Room_SuperAdmin_unLimmit),@(Custom_Noti_Sub_Room_SuperAdmin_unLock),@(Custom_Noti_Sub_Room_SuperAdmin_LockMic),@(Custom_Noti_Sub_Room_SuperAdmin_noVoiceMic),@(Custom_Noti_Sub_Room_SuperAdmin_DownMic),@(Custom_Noti_Sub_Room_SuperAdmin_Shield),@(Custom_Noti_Sub_Room_SuperAdmin_TickRoom),@(Custom_Noti_Sub_Room_SuperAdmin_TickManagerRoom),@(Custom_Noti_Sub_Room_SuperAdmin_CloseChat),@(Custom_Noti_Sub_Room_SuperAdmin_CloseRoom), nil],
                     @(Custom_Noti_Header_RoomPublicScreen):
                     [NSSet setWithObjects:
                      @(Custom_Noti_Sub_RoomPublicScreen_greeting),
                      nil],
                     @(Custom_Noti_Header_Red):
                     [NSSet setWithObjects:
                      @(Custom_Noti_Sub_Red_Room_Current),
                      @(Custom_Noti_Sub_Red_Room_Other),
                      @(Custom_Noti_Sub_Red_Room_Draw),
                      nil],
                     @(Custom_Noti_Header_RoomLoveModelFirst) : [NSSet setWithObjects:@(Custom_Noti_Sub_Room_LoveModel_Sec_SrceenMsg),
                                                                       @(Custom_Noti_Sub_Room_LoveModel_Sec_Anmintions),
                                                                       @(Custom_Noti_Sub_Room_LoveModel_Sec_DownMicToast),
                                                                       @(Custom_Noti_Sub_Room_LoveModel_Sec_SuccessMsg),@(Custom_Noti_Sub_Room_LoveModel_Sec_PublicLoveEffect),
                                                                       nil],
                     };
    });
    return instance;
}

@end
