//
//  TTDisplayModelMaker+Face.m
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker+Face.h"

@implementation TTDisplayModelMaker (Face)

- (NSMutableAttributedString *)creatFaceAttributedWithMsg:(NIMMessage *)message withModel:(TTMessageDisplayModel *)model{
    if (message) {
        NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
        if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
            Attachment *attachment = (Attachment *)obj.attachment;
            FaceSendInfo *faceattachement = [FaceSendInfo yy_modelWithJSON:attachment.data];
            NSMutableArray *arr = [faceattachement.data mutableCopy];//接受人数
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
            if (arr.count > 0) {
                NSMutableAttributedString *wholeStr = [[NSMutableAttributedString alloc]init];
                for (int i = 0; i < arr.count; i++) {
                    FaceReceiveInfo *item = arr[i];
                    //发送者的贵族信息
                    SingleNobleInfo *senderNobleInfo = [TTMessageHelper handleRoomExtToModel:message.remoteExt uid:[NSString stringWithFormat:@"%lld",item.uid]];
                    LevelInfo *sendlevelInfo = [TTMessageHelper handleRoomExtToLevelModel:message.remoteExt uid:[NSString stringWithFormat:@"%lld",item.uid]];
                    NSString *content = nil;
                    
                    NSMutableAttributedString *nickStr = [BaseAttrbutedStringHandler creatStrAttrByStr:item.nick attributed:[BaseAttrbutedStringHandler textAttributedWithColor:[UIColor redColor] size:TTMessageViewDefaultFontSize]];
                    
                    [nickStr yy_setTextHighlightRange:NSMakeRange(0, nickStr.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                        @KWeakify(self);
                        if (model.textDidClick) {
                            model.textDidClick(item.uid);
                        }
                    }];
                    
                    
                    [str appendAttributedString:nickStr];
                    NSMutableAttributedString *sysblom = [BaseAttrbutedStringHandler creatStrAttrByStr:@":"];
                    [str appendAttributedString:sysblom];
                    
                    [str addAttribute:NSForegroundColorAttributeName
                                value:UIColorRGBAlpha(0xffffff, 0.5)
                                range:NSMakeRange(0, str.length)];
                    
                    for (int j = 0; j < item.resultIndexes.count; j++) {
                        NSNumber *index = item.resultIndexes[j];
                        UIImage *face = [GetCore(FaceCore)findFaceImageById:item.faceId index:[index integerValue]];
                        
                        CALayer *imageViewLayer = [[CALayer alloc]init];
                        imageViewLayer.contents = (__bridge id)face.CGImage;
                        imageViewLayer.contentsGravity = kCAGravityResizeAspect;
                        imageViewLayer.contentsScale = [UIScreen mainScreen].scale;
                        imageViewLayer.bounds = CGRectMake(0, 0, 30, 30);
                        
                        NSMutableAttributedString * imageString1 = [NSMutableAttributedString yy_attachmentStringWithContent:imageViewLayer contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(imageViewLayer.frame.size.width, imageViewLayer.frame.size.height) alignToFont:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] alignment:YYTextVerticalAlignmentCenter];
                        [str appendAttributedString:imageString1];
                    }
                    
                    if (arr.count > 1 && i != arr.count - 1) {
                        NSString *returnStr = @"\n";
                        NSMutableAttributedString *returnAttStr = [[NSMutableAttributedString alloc] initWithString:returnStr];
                        [str appendAttributedString:returnAttStr];
                    }
                    str.yy_lineSpacing = 5;
                    [wholeStr appendAttributedString:str];
                    
                }
                [wholeStr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]
                                 range:NSMakeRange(0,wholeStr.length)];
                return wholeStr;
            }
        }
    }
    return nil;
}

@end
