//
//  XCApprenticeTipsMessageContentView.m
//  TTPlay
//
//  Created by gzlx on 2019/2/14.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "XCApprenticeTipsMessageContentView.h"
#import "XCMacros.h"
#import "UIView+NIM.h"
#import "Attachment.h"
#import "XCMentoringShipAttachment.h"
#import "XCTheme.h"
#import "NIMKit.h"

@implementation XCApprenticeTipsMessageContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        [self addSubview:self.msgLabel];
    }
    return self;
}


- (void)refresh:(NIMMessageModel *)model{
    [super refresh:model];
    NIMCustomObject * customObject = model.message.messageObject;
    Attachment * attach =(Attachment *)customObject.attachment;
    if (attach.first == Custom_Noti_Header_Mentoring_RelationShip) {
        XCMentoringShipAttachment * mentoringAttach = [XCMentoringShipAttachment yy_modelWithDictionary:attach.data];
        self.msgLabel.text = mentoringAttach.tips;
        self.msgLabel.nim_width = [self messageShipsWidthWith:mentoringAttach.tips].width + 10;
        self.msgLabel.nim_height = (int)[self messageShipsWidthWith:mentoringAttach.tips].height + 5;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.nim_width = [UIScreen mainScreen].bounds.size.width;
    self.bubbleImageView.hidden = YES;
    if (self.frame.origin.x >= 0) {
        self.msgLabel.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.msgLabel.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 26;
    }
    self.msgLabel.nim_centerY = self.nim_height * .5f;
}



- (CGSize)messageShipsWidthWith:(NSString *)messageTips{
    return [messageTips boundingRectWithSize:CGSizeMake(KScreenWidth - 60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
}

#pragma mark - setters and getters
- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.backgroundColor = UIColorFromRGB(0xd6d6d6);
        _msgLabel.layer.masksToBounds = YES;
        _msgLabel.layer.cornerRadius = 5;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = [UIFont systemFontOfSize:12];
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.numberOfLines = 2;
    }
    return _msgLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
