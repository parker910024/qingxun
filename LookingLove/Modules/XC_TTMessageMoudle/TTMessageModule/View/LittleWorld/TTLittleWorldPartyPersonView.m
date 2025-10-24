//
//  TTLittleWorldPartyPersonView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/1.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldPartyPersonView.h"
#import <YYText/YYLabel.h>
#import <YYText/YYText.h>
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "BaseAttrbutedStringHandler.h"

@interface TTLittleWorldPartyPersonView ()
/** 显示人数*/
@property (nonatomic,strong) YYLabel *titleLabel;
/** 关闭*/
@property (nonatomic,strong) UIButton *closeButton;

@end

@implementation TTLittleWorldPartyPersonView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - reponse
- (void)didClickPersinViewRecognizer:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttLittleWorldPartyPersonViewCheckPartyInTeam:)]) {
        [self.delegate ttLittleWorldPartyPersonViewCheckPartyInTeam:self];
    }
}

#pragma mark - public method
- (void)updateLittleWorldPartyNumberPersonWithPerson:(NSInteger)person {
    self.titleLabel.attributedText = [self creatLittleWorldNumberOfPersonInPartyWith:person];
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];

    self.backgroundColor = UIColorFromRGB(0xCEF1EB);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickPersinViewRecognizer:)];
    [self addGestureRecognizer:tap];
    
}

- (void)initContrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.centerY.mas_equalTo(self);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-9);
    }];

}

- (NSMutableAttributedString *)creatLittleWorldNumberOfPersonInPartyWith:(NSInteger)number {
    NSString * person = [NSString stringWithFormat:@"%ld人正在派对", number];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] init];
    [attribute appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:person attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x2FCB96)}]];
    [attribute appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:7]];
    [attribute appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 6, 9) urlString:nil imageName:@"littleworld_topic_arrow"]];
   
    return attribute;
}



#pragma mark - setters and getters
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"littleworld_topic_close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"littleworld_topic_close"] forState:UIControlStateSelected];
    }
    return _closeButton;
}

@end
