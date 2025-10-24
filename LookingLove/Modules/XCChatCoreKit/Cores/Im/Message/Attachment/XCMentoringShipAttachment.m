//
//  XCMentoringShipAttachment.m
//  XCChatCoreKit
//
//  Created by gzlx on 2019/1/21.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "XCMentoringShipAttachment.h"

@implementation XCMentoringShipAttachment

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
             @"extendData":@"data"
             };
}



- (NSString *)cellContent:(NIMMessage *)message {
    NIMCustomObject * customObject = message.messageObject;
    Attachment *attachMent= (Attachment *)customObject.attachment;
    //
    if (attachMent.first == Custom_Noti_Header_Mentoring_RelationShip) {
        //师傅的第一个任务
        if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master) {
            return @"XCMasterFirstTaskMessageContentView";
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Master){
            return @"XCMasterSecondTaskMessageContentView";
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Master){
            return @"XCMasterThirdTaskMessageContentView";
        }else if(attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Master){
            return @"XCMasterFourthTaskMessageContentView";
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Apprentice){
            return @"XCApprenticeSecondFollowMessageContentView";
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Apprentice){
            return @"XCApprenticeFlowerMessageContentView";
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Apprentice){
            return @"XCMasterSecondTaskMessageContentView";
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Apprentice){
            return @"XCApprenticeAcceptMessageContentView";
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master_Tips || attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Tips || attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Fail_Tips ||
                  attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Result){
            return @"XCApprenticeTipsMessageContentView";
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite){
            return @"XCMentoringInviteMessageContentView";
        }else{
            return @"";
        }
    }
     return @"";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    NIMCustomObject * customObject = message.messageObject;
    Attachment *attachMent= (Attachment *)customObject.attachment;
    //
    if (attachMent.first == Custom_Noti_Header_Mentoring_RelationShip) {
        //师傅的第一个任务
        if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master || attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Master) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 220 + 23);
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Master){
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 210 + 23);
        }else if(attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Master){
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 192);
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Apprentice){
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 252);
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Apprentice){
            return CGSizeMake([UIScreen mainScreen].bounds.size.width - 128, 125);
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Apprentice){
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 220 + 23);
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Apprentice){
            return CGSizeMake(251, 113);
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master_Tips || attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Tips || attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Result || attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Fail_Tips){
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
        }else if (attachMent.second == Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite){
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 220 + 23);
        }else{
            return CGSizeZero;
        }
    }
    return CGSizeZero;
}

@end
