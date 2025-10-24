//
//  RedPacketDetailInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "RedPacketDetailInfo.h"
#import "NSObject+YYModel.h"
#import <YYText/YYText.h>
#import "AuthCore.h"

@implementation RedPacketDetailInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"members":[RedPacketRecordInfo class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"status" : @[@"status",@"claimStatus"],
             @"claimedAmount":@"claimedAmount",
             };
}

- (NSString *)cellContent:(NIMMessage *)message {
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    RedPacketDetailInfo *attachment = (RedPacketDetailInfo *)object.attachment;
    if (attachment.second == Custom_Noti_Sub_Header_Group_RedPacket_Tips) {
        return @"XCTipsContentView";
    }
    
    return @"XCRedContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    Attachment *attachment = (Attachment *)object.attachment;
   
    if (attachment.second == Custom_Noti_Sub_Header_Group_RedPacket_Tips) {
        RedPacketDetailInfo *data = [RedPacketDetailInfo yy_modelWithJSON:attachment.data];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = [UIImage imageNamed:@"message_chat_red_has_adopt"];
        attch.bounds = CGRectMake(0, 0, 14, 17);
        //创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];

        if (data.receiveNick.length > 0) {
            NSString *role = data.receiveUid == [GetCore(AuthCore)getUid].userIDValue ? data.nick : @"你";
            NSString *str = [NSString stringWithFormat:@"%@领了%@的",data.receiveNick,role];
            
            [att appendAttributedString:string];
            [att appendAttributedString:[[NSAttributedString alloc]initWithString:str]];
            
//            [att setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(att.length - 2, 2)];
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.attributedText  = att;
        label.font = [UIFont boldSystemFontOfSize:10];
        label.numberOfLines = 0;
        CGFloat padding = 20.f;
        CGSize size = [label sizeThatFits:CGSizeMake(width - 2 * padding, CGFLOAT_MAX)];
        CGFloat cellPadding = 11.f;
        CGSize contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-padding*2, size.height + 2 * cellPadding);
        return contentSize;
    }else {
        return CGSizeMake(236.5,78);
    }
    
}

@end
