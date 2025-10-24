//
//  CTDynamicModel.m
//  UKiss
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "CTCommentReplyModel.h"
#import "M80AttributedLabel+NIMKit.h"
#import "XCMacros.h"
#import "XCTheme.h"

@implementation CTReplyModel


@end

@implementation CTReplyInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"replyList" : [CTReplyModel class]
             };
}
@end

@interface CTCommentReplyModel ()

@property (nonatomic, strong) M80AttributedLabel *cacheLab;

@end

@implementation CTCommentReplyModel


- (CGFloat)getCommentHeight {
    if (self.cacheHeaderHeight) {
        return self.cacheHeaderHeight;
    }
    [self.cacheLab nim_setText:self.content];
    CGFloat msgBubbleMaxWidth = (KScreenWidth - 75);
    CGSize  contentSize = [self.cacheLab sizeThatFits:CGSizeMake(msgBubbleMaxWidth, CGFLOAT_MAX)];
    self.cacheHeaderHeight = contentSize.height + 80;
    return self.cacheHeaderHeight;
}

- (M80AttributedLabel *)cacheLab {
    if (!_cacheLab) {
        _cacheLab = [[M80AttributedLabel alloc]init];
        _cacheLab.textColor = UIColorFromRGB(0x666666);
        _cacheLab.font = [UIFont systemFontOfSize:14];
        _cacheLab.numberOfLines = 0;
        _cacheLab.lineBreakMode = NSLineBreakByCharWrapping;
        _cacheLab.autoDetectLinks = NO;
    }
    return _cacheLab;
}


@end
