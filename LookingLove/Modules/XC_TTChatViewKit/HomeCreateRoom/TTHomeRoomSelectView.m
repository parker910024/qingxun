//
//  TTHomeRoomSelectView.m
//  TuTu
//
//  Created by new on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTHomeRoomSelectView.h"
#import <Masonry/Masonry.h>
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "XCTheme.h"
#import "XCMacros.h"

@implementation TTHomeRoomSelectView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.roomSelectBackView];
        [self.roomSelectBackView addSubview:self.ordinaryButton];
        [self.roomSelectBackView addSubview:self.companyButton];
        [self.roomSelectBackView addSubview:self.ordinaryLabel];
        [self.roomSelectBackView addSubview:self.companyLabel];
        [self.roomSelectBackView addSubview:self.roomShowsButton];
        
        [self addSubview:self.roomShowsView];
        [self.roomShowsView addSubview:self.roomTitleLabel];
        [self.roomShowsView addSubview:self.roomOrdinaryTitleLabel];
        [self.roomShowsView addSubview:self.roomOrdinaryContentLabel];
        [self.roomShowsView addSubview:self.roomCompanyTitleLabel];
        [self.roomShowsView addSubview:self.roomCompanyContentLabel];
        [self.roomShowsView addSubview:self.roomShowsCloseButton];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *selectBackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerViewAction)];
        [self.roomSelectBackView addGestureRecognizer:selectBackViewTap];
        
        UITapGestureRecognizer *roomShowsViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerViewAction)];
        [self.roomShowsView addGestureRecognizer:roomShowsViewTap];
        
        [self initConstraints];
    }
    return self;
}

- (void)tapAction {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchMaskBackground)]) {
        [self.delegate touchMaskBackground];
    }
}

- (void)tapContainerViewAction {
    /// 无操作，拦截 tapAction 事件的作用
}

-(UIView *)roomSelectBackView{
    if (!_roomSelectBackView) {
        self.roomSelectBackView = [[UIView alloc] init];
        _roomSelectBackView.layer.cornerRadius = 10;
        _roomSelectBackView.layer.masksToBounds = YES;
        _roomSelectBackView.backgroundColor = UIColor.whiteColor;
    }
    return _roomSelectBackView;
}

-(UIButton *)ordinaryButton{
    if (!_ordinaryButton) {
        self.ordinaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ordinaryButton setImage:[UIImage imageNamed:@"room_game_ordinary"] forState:UIControlStateNormal];
        [_ordinaryButton addTarget:self action:@selector(ordinaryAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ordinaryButton;
}

-(UIButton *)companyButton{
    if (!_companyButton) {
        self.companyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_companyButton setImage:[self companyButtonImage] forState:UIControlStateNormal];
        [_companyButton addTarget:self action:@selector(companyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _companyButton;
}

- (UIImage *)companyButtonImage {
    UIImage *image = [UIImage imageNamed:@"room_game_ company"];
    if (image == nil) {
        image = [UIImage imageNamed:@"room_game_company"];
    }
    return image;
}

-(UILabel *)ordinaryLabel{
    if (!_ordinaryLabel) {
        self.ordinaryLabel = [[UILabel alloc] init];
        _ordinaryLabel.text = @"普通房";
        _ordinaryLabel.font = [UIFont systemFontOfSize:14];
        _ordinaryLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [_ordinaryLabel sizeToFit];
    }
    return _ordinaryLabel;
}

-(UILabel *)companyLabel{
    if (!_companyLabel) {
        self.companyLabel = [[UILabel alloc] init];
        _companyLabel.text = @"陪伴房";
        _companyLabel.font = [UIFont systemFontOfSize:14];
        _companyLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [_companyLabel sizeToFit];
    }
    return _companyLabel;
}

-(UIButton *)roomShowsButton{
    if (!_roomShowsButton) {
        self.roomShowsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_roomShowsButton setTitle:@"房间说明>" forState:UIControlStateNormal];
        _roomShowsButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_roomShowsButton setTitleColor:[self roomShowsButtonColor] forState:UIControlStateNormal];
        [_roomShowsButton sizeToFit];
        [_roomShowsButton addTarget:self action:@selector(roomShowsOpenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _roomShowsButton;
}

- (UIColor *)roomShowsButtonColor {
    if (projectType() == ProjectType_CeEr) {
        return UIColorFromRGB(0x34EBDE);
    }
    return [XCTheme getTTMainColor];
}

-(void)roomShowsOpenAction{
    self.roomShowsView.hidden = NO;
}

-(void)roomShowsCloseAction{
    self.roomShowsView.hidden = YES;
}

-(UIView *)roomShowsView{
    if (!_roomShowsView) {
        self.roomShowsView = [[UIView alloc] init];
        _roomShowsView.backgroundColor = UIColor.whiteColor;
        _roomShowsView.layer.cornerRadius = 14;
        _roomShowsView.layer.masksToBounds = YES;
        _roomShowsView.hidden = YES;
    }
    return _roomShowsView;
}

-(UILabel *)roomTitleLabel{
    if (!_roomTitleLabel) {
        self.roomTitleLabel = [[UILabel alloc] init];
        _roomTitleLabel.text = @"房间说明";
        _roomTitleLabel.textColor = [XCTheme getTTMainColor];
        _roomTitleLabel.font = [UIFont systemFontOfSize:18];
        [_roomTitleLabel sizeToFit];
    }
    return _roomTitleLabel;
}

-(UIButton *)roomShowsCloseButton{
    if (!_roomShowsCloseButton) {
        self.roomShowsCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_roomShowsCloseButton setImage:[UIImage imageNamed:@"room_gameShows_close"] forState:UIControlStateNormal];
        [_roomShowsCloseButton addTarget:self action:@selector(roomShowsCloseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _roomShowsCloseButton;
}

-(UILabel *)roomOrdinaryTitleLabel{
    if (!_roomOrdinaryTitleLabel) {
        self.roomOrdinaryTitleLabel = [[UILabel alloc] init];
        _roomOrdinaryTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _roomOrdinaryTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _roomOrdinaryTitleLabel.text = @"什么是普通房？";
        [_roomOrdinaryTitleLabel sizeToFit];
    }
    return _roomOrdinaryTitleLabel;
}

-(UILabel *)roomOrdinaryContentLabel{
    if (!_roomOrdinaryContentLabel) {
        self.roomOrdinaryContentLabel = [[UILabel alloc] init];
        _roomOrdinaryContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _roomOrdinaryContentLabel.font = [UIFont systemFontOfSize:14];
        _roomOrdinaryContentLabel.numberOfLines = 0;
        _roomOrdinaryContentLabel.text = @"在普通房可以和七八个朋友一起谈天说地、K歌欢唱，找声音好听的小哥哥小姐姐一起PK，共同开启声音盛宴！";
    }
    return _roomOrdinaryContentLabel;
}

-(UILabel *)roomCompanyTitleLabel{
    if (!_roomCompanyTitleLabel) {
        self.roomCompanyTitleLabel = [[UILabel alloc] init];
        _roomCompanyTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _roomCompanyTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _roomCompanyTitleLabel.text = @"什么是陪伴房？";
        [_roomCompanyTitleLabel sizeToFit];
    }
    return _roomCompanyTitleLabel;
}

-(UILabel *)roomCompanyContentLabel{
    if (!_roomCompanyContentLabel) {
        self.roomCompanyContentLabel = [[UILabel alloc] init];
        _roomCompanyContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _roomCompanyContentLabel.font = [UIFont systemFontOfSize:14];
        _roomCompanyContentLabel.numberOfLines = 0;
        _roomCompanyContentLabel.text = @"陪伴房给你更私密的空间，在房间中，你们可以一起听自己喜欢的音乐、陪连麦、用声音感觉你在身边。相互感觉彼此！";
    }
    return _roomCompanyContentLabel;
}

-(void)initConstraints{
    [self.roomSelectBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(311, 161));
        make.center.mas_equalTo(self.center);
    }];
    
    [self.ordinaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.left.mas_equalTo(57);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [self.ordinaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ordinaryButton.mas_bottom).offset(3);
        make.centerX.equalTo(self.ordinaryButton.mas_centerX);
    }];
    
    [self.companyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.right.mas_equalTo(-57);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyButton.mas_bottom).offset(3);
        make.centerX.equalTo(self.companyButton.mas_centerX);
    }];
 
    [self.roomShowsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-16);
        make.centerX.equalTo(self.roomSelectBackView.mas_centerX);
    }];
    
    [self.roomShowsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(311, 311));
        make.center.mas_equalTo(self.center);
    }];
    
    [self.roomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19);
        make.top.mas_equalTo(32);
    }];
    
    [self.roomShowsCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
    
    [self.roomCompanyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19);
        make.top.equalTo(self.roomTitleLabel.mas_bottom).offset(28);
    }];
    
    [self.roomCompanyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        make.top.equalTo(self.roomCompanyTitleLabel.mas_bottom).offset(15);
    }];
    
    [self.roomShowsView layoutIfNeeded];
    self.roomCompanyContentLabel.preferredMaxLayoutWidth = self.roomShowsView.frame.size.width - 21 * 2;//给一个maxWidth
    [self.roomCompanyContentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.roomOrdinaryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19);
        make.top.equalTo(self.roomCompanyContentLabel.mas_bottom).offset(28);
    }];
    
    [self.roomOrdinaryContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        make.top.equalTo(self.roomOrdinaryTitleLabel.mas_bottom).offset(15);
    }];
    self.roomOrdinaryContentLabel.preferredMaxLayoutWidth = self.roomShowsView.frame.size.width - 21 * 2;//给一个maxWidth
    [self.roomOrdinaryContentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

-(void)ordinaryAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ordinaryButtonActionResponse)]) {
        [self.delegate ordinaryButtonActionResponse];
    }
}

-(void)companyAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(companyButtonActionResponse)]) {
        [self.delegate companyButtonActionResponse];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
