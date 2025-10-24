//
//  TTVoiceTimeView.m
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceTimeView.h"
#import <YYText/YYLabel.h>
#import <Masonry/Masonry.h>
#import "BaseAttrbutedStringHandler.h"

@interface TTVoiceTimeView ()

/** 录音上面显示文字*/
@property (nonatomic,strong) YYLabel *contentLabel;;

@end


@implementation TTVoiceTimeView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - private method
- (void)initView {
    [self addSubview:self.contentLabel];
}

- (void)initContrations {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - public method
- (void)setSecond:(NSTimeInterval)second totalSecond:(NSTimeInterval)totalSecond{
    self.second = second;
    NSInteger min = (NSInteger)(second / 60) % 60;
    NSInteger sec = (NSInteger)second % 60;
    
    NSInteger t_min = (NSInteger)(totalSecond / 60) % 60;
    NSInteger t_sec = (NSInteger)totalSecond % 60;
    self.contentLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld:%02ld | %02ld:%02ld",min,sec,t_min,t_sec] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
}


- (void)updateContentWith:(NSString *)content isRecordShort:(BOOL)isShort {
    NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] init];
    if (isShort) {
        [attribut appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 15, 15) urlString:nil imageName:@"game_voice_record_short"]];
        [attribut appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:4]];
    }
    [attribut appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:content attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    self.contentLabel.attributedText  = attribut;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - setters and getters
- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
    }
    return _contentLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
