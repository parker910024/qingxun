//
//  XCCPGamePrivateSysNotiView.m
//  TTPlay
//
//  Created by new on 2019/2/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCCPGamePrivateSysNotiView.h"
#import <Masonry/Masonry.h>
#import "NSObject+YYModel.h"
#import "XCTheme.h"
#import "XCCPGamePrivateSysNotiAttachment.h"
#import "TTGameCPPrivateSysNotiModel.h"

#import "TTCPGamePrivateChatCore.h"
#import "TTGameCPPrivateChatModel.h"
#import "ImMessageCore.h"
#import "AuthCore.h"
#import "UIView+NIM.h"

@interface XCCPGamePrivateSysNotiView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *titleButton;

@end

@implementation XCCPGamePrivateSysNotiView


- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        
        [self initView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    XCCPGamePrivateSysNotiAttachment *customObject = (XCCPGamePrivateSysNotiAttachment*)object.attachment;
    
    TTGameCPPrivateSysNotiModel *model = [TTGameCPPrivateSysNotiModel modelDictionary:customObject.data];
    [self.titleButton setTitle:[NSString stringWithFormat:@"   %@   ",model.msg] forState:UIControlStateNormal];
    
    NSString *titleString = [NSString stringWithFormat:@"   %@   ",model.msg];
    CGSize size = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    if (size.width < KScreenWidth) {
        [self.titleButton sizeToFit];
    }else{
        self.titleButton.nim_size = CGSizeMake(KScreenWidth, 30);
    }
    
}


- (void)initView
{
    [self addSubview:self.backView];
    
    self.bubbleImageView.hidden = YES;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
    
    [self.backView addSubview:self.titleButton];
}

- (void)layoutSubviews{

    [self.backView layoutIfNeeded];
    
    self.titleButton.nim_centerY = self.nim_height / 2;
    self.titleButton.layer.cornerRadius = 6;
    if (self.frame.origin.x >= 0) {
        self.titleButton.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.titleButton.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 6;
    }
    
}

- (UIButton *)titleButton{
    if (_titleButton == nil) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _titleButton.backgroundColor = UIColorFromRGB(0xD6D6D6);
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _titleButton.titleLabel.numberOfLines = 0;
        _titleButton.userInteractionEnabled = NO;
        _titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleButton;
}

- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _backView;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
