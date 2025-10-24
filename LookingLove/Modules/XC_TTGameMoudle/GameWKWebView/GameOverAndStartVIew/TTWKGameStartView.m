//
//  TTWKGameStartView.m
//  TTPlay
//
//  Created by new on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWKGameStartView.h"

#import <Masonry/Masonry.h>
#import "UIButton+EnlargeTouchArea.h"
#import "XCMacros.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import "UIColor+UIColor_Hex.h"
#import "MeetingCore.h"

@interface TTWKGameStartView ()

@property (nonatomic, strong) UIView *topBackView; // 游戏页面上方半透明view
@property (nonatomic, strong) UIButton *changeWatchBtn; // 切换观战
@property (nonatomic, strong) UIImageView *myAvatorImageViw; //  我的头像
@property (nonatomic, strong) UIImageView *myGenderImageView; // 我的性别
@property (nonatomic, strong) UIImageView *youAvatorImageView;  // 对方的头像
@property (nonatomic, strong) UIImageView *youGenderImageView; // 对方的性别
@property (nonatomic, strong) UILabel *myTitleLabel; // 我的姓名
@property (nonatomic, strong) UILabel *youTitleLabel; // 对方的姓名
@property (nonatomic, strong) UIButton *myButton; //  开麦
@property (nonatomic, strong) UIButton *youButton; // 静音



@end

@implementation TTWKGameStartView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addInitView];
        
         [self initConstraint];
    }
    
    return self;
}

- (void)addInitView{
    [self addSubview:self.topBackView];
    [self.topBackView addSubview:self.myAvatorImageViw];
    [self.topBackView addSubview:self.myGenderImageView];
    
    [self.topBackView addSubview:self.youAvatorImageView];
    [self.topBackView addSubview:self.youGenderImageView];
    
    [self.topBackView addSubview:self.myTitleLabel];
    [self.topBackView addSubview:self.youTitleLabel];
    
    [self.topBackView addSubview:self.myButton];
    [self.topBackView addSubview:self.youButton];
    [self.topBackView addSubview:self.changeWatchBtn];
}

- (void)initConstraint{
    [self.topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(55);
    }];

    [self.myAvatorImageViw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBackView.mas_left).offset(7);
        make.top.mas_equalTo(self.topBackView.mas_top).offset(7);
        make.size.mas_equalTo(CGSizeMake(41, 41));
    }];
    [self.myAvatorImageViw layoutIfNeeded];
    self.myAvatorImageViw.layer.cornerRadius = self.myAvatorImageViw.frame.size.height / 2;

    [self.myGenderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.myAvatorImageViw.mas_right).offset(3);
        make.bottom.mas_equalTo(self.myAvatorImageViw.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];

    [self.youAvatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBackView.mas_top).offset(7);
        make.right.mas_equalTo(self.topBackView.mas_right).offset(-7);
        make.size.mas_equalTo(CGSizeMake(41, 41));
    }];
    [self.youAvatorImageView layoutIfNeeded];
    self.youAvatorImageView.layer.cornerRadius = self.youAvatorImageView.frame.size.width / 2;

    [self.youGenderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.youAvatorImageView.mas_left).offset(-3);
        make.bottom.mas_equalTo(self.youAvatorImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];

    [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myAvatorImageViw.mas_top).offset(7);
        make.left.mas_equalTo(self.myAvatorImageViw.mas_right).offset(10);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(70);
    }];

    [self.youTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.youAvatorImageView.mas_top).offset(7);
        make.right.mas_equalTo(self.youAvatorImageView.mas_left).offset(-10);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(70);
    }];


    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myTitleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.myTitleLabel.mas_left);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(16);
    }];
    [self.myButton layoutIfNeeded];
    _myButton.imageFrame = [NSValue valueWithCGRect:CGRectMake(4, 3, 10, 10)];
    _myButton.titleFrame = [NSValue valueWithCGRect:CGRectMake(18, 3, _myButton.frame.size.width - 18, 9)];

    [self.youButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.youTitleLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.youTitleLabel.mas_right);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(16);
    }];
    [self.youButton layoutIfNeeded];
    _youButton.imageFrame = [NSValue valueWithCGRect:CGRectMake(4, 3, 10, 10)];
    _youButton.titleFrame = [NSValue valueWithCGRect:CGRectMake(18, 3, _youButton.frame.size.width - 18, 9)];
    
    [self.changeWatchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.topBackView);
    }];
}

- (void)setHiddenWatchBtnBool:(BOOL)hiddenWatchBtnBool{
    if (hiddenWatchBtnBool) {
        self.changeWatchBtn.hidden = YES;
    }else{
        self.changeWatchBtn.hidden = NO;
    }

}

- (void)setDataModel:(TTGameInformationModel *)dataModel{
    if (self.watching) {
        _myButton.hidden = YES;
        _youButton.hidden = YES;
        [[GetCore(UserCore) getUserInfoByRac:dataModel.uidLeft refresh:NO] subscribeNext:^(id x) {
            UserInfo *info = x;
            [self.myAvatorImageViw qn_setImageImageWithUrl:info.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            
            self.myTitleLabel.text = info.nick;
            
            UserGender myGender = info.gender;
            
            NSString *myImageName;
            if (myGender == 1) {
                myImageName = @"game_gender_boy";
                
            }else{
                myImageName = @"game_gender_girl";
                
            }
            self.myGenderImageView.image = [UIImage imageNamed:myImageName];
        }];
        
        
        [[GetCore(UserCore) getUserInfoByRac:dataModel.uidRight refresh:NO] subscribeNext:^(id x) {
            
            UserInfo *info = x;
            
            [self.youAvatorImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            
            self.youTitleLabel.text = info.nick;
            
            UserGender youGender = info.gender;
            
            NSString *youImageName;
            if (youGender == 1) {
                youImageName = @"game_gender_boy";
            }else{
                youImageName = @"game_gender_girl";
            }
            
            self.youGenderImageView.image = [UIImage imageNamed:youImageName];
        }];
        
    }else{
        _myButton.hidden = NO;
        _youButton.hidden = NO;
    if (dataModel.uidLeft == GetCore(AuthCore).getUid.userIDValue) {
        [[GetCore(UserCore) getUserInfoByRac:dataModel.uidLeft refresh:NO] subscribeNext:^(id x) {
            UserInfo *info = x;
            [self.myAvatorImageViw qn_setImageImageWithUrl:info.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            
            self.myTitleLabel.text = info.nick;
            
            UserGender myGender = info.gender;
            
            NSString *myImageName;
            if (myGender == 1) {
                myImageName = @"game_gender_boy";
                
            }else{
                myImageName = @"game_gender_girl";
                
            }
            self.myGenderImageView.image = [UIImage imageNamed:myImageName];
        }];
        
        
        [[GetCore(UserCore) getUserInfoByRac:dataModel.uidRight refresh:NO] subscribeNext:^(id x) {
            
            UserInfo *info = x;
            
            [self.youAvatorImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            
            self.youTitleLabel.text = info.nick;
            
            UserGender youGender = info.gender;
            
            NSString *youImageName;
            if (youGender == 1) {
                youImageName = @"game_gender_boy";
            }else{
                youImageName = @"game_gender_girl";
            }
            
            self.youGenderImageView.image = [UIImage imageNamed:youImageName];
        }];
        
    }else{
        
        [[GetCore(UserCore) getUserInfoByRac:dataModel.uidRight refresh:NO] subscribeNext:^(id x) {
            UserInfo *info = x;
            [self.myAvatorImageViw qn_setImageImageWithUrl:info.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            
            self.myTitleLabel.text = info.nick;
            
            UserGender myGender = info.gender;
            
            NSString *myImageName;
            if (myGender == 1) {
                myImageName = @"game_gender_boy";
                
            }else{
                myImageName = @"game_gender_girl";
                
            }
            self.myGenderImageView.image = [UIImage imageNamed:myImageName];
        }];
        
        
        [[GetCore(UserCore) getUserInfoByRac:dataModel.uidLeft refresh:NO] subscribeNext:^(id x) {
            
            UserInfo *info = x;
            
            [self.youAvatorImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            
            self.youTitleLabel.text = info.nick;
            
            UserGender youGender = info.gender;
            
            NSString *youImageName;
            if (youGender == 1) {
                youImageName = @"game_gender_boy";
            }else{
                youImageName = @"game_gender_girl";
            }
            
            self.youGenderImageView.image = [UIImage imageNamed:youImageName];
        }];
    }
    }
}


#pragma mark -- button 点击事件 ---
- (void)microphoneCloseOrOpen:(UIButton *)sender{
    sender.selected = sender.selected ? NO : YES;
    sender.imageFrame = [NSValue valueWithCGRect:CGRectMake(4, 3, 10, 10)];
    sender.titleFrame = [NSValue valueWithCGRect:CGRectMake(18, 3, sender.frame.size.width - 18, 9)];
    
    [GetCore(MeetingCore) setCloseMicro:!GetCore(MeetingCore).isCloseMicro];
}

- (void)voiceCloseOrOpen:(UIButton *)sender{
    sender.selected = sender.selected ? NO : YES;
    sender.imageFrame = [NSValue valueWithCGRect:CGRectMake(4, 3, 10, 10)];
    sender.titleFrame = [NSValue valueWithCGRect:CGRectMake(18, 3, sender.frame.size.width - 18, 9)];
    
    [GetCore(MeetingCore) setMute:!GetCore(MeetingCore).isMute];
}

- (void)changeWatchActionHandle:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchChangeWatch)]) {
        [self.delegate switchChangeWatch];
    }
}

#pragma mark --- setter ---
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
        _topBackView.backgroundColor = [UIColor colorWithHexString:@"25000000"];
        _topBackView.layer.cornerRadius = 28;
        _topBackView.layer.masksToBounds = YES;
    }
    return _topBackView;
}

- (UIImageView *)myAvatorImageViw{
    if (!_myAvatorImageViw) {
        _myAvatorImageViw = [[UIImageView alloc] init];
        _myAvatorImageViw.layer.masksToBounds = YES;
    }
    return _myAvatorImageViw;
}

- (UIImageView *)myGenderImageView{
    if (!_myGenderImageView) {
        _myGenderImageView = [[UIImageView alloc] init];
    }
    return _myGenderImageView;
}

- (UIImageView *)youAvatorImageView{
    if (!_youAvatorImageView) {
        _youAvatorImageView = [[UIImageView alloc] init];
        _youAvatorImageView.layer.masksToBounds = YES;
    }
    return _youAvatorImageView;
}

- (UIImageView *)youGenderImageView{
    if (!_youGenderImageView) {
        _youGenderImageView = [[UIImageView alloc] init];
    }
    return _youGenderImageView;
}

- (UILabel *)myTitleLabel{
    if (!_myTitleLabel) {
        _myTitleLabel = [[UILabel alloc] init];
        _myTitleLabel.textColor = UIColor.whiteColor;
        _myTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _myTitleLabel;
}

- (UILabel *)youTitleLabel{
    if (!_youTitleLabel) {
        _youTitleLabel = [[UILabel alloc] init];
        _youTitleLabel.textColor = UIColor.whiteColor;
        _youTitleLabel.font = [UIFont systemFontOfSize:12];
        _youTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _youTitleLabel;
}

- (UIButton *)myButton{
    if (!_myButton) {
        _myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myButton setBackgroundImage:[UIImage imageNamed:@"game_button_bg"] forState:UIControlStateNormal];
        [_myButton setBackgroundImage:[UIImage imageNamed:@"game_button_bg_ash"] forState:UIControlStateSelected];
        [_myButton setTitle:@"已开麦" forState:UIControlStateNormal];
        [_myButton setTitle:@"已闭麦" forState:UIControlStateSelected];
        [_myButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_myButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        _myButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [_myButton setImage:[UIImage imageNamed:@"game_button_wheat_on"] forState:UIControlStateNormal];
        [_myButton setImage:[UIImage imageNamed:@"game_button_wheat_off"] forState:UIControlStateSelected];
        [_myButton addTarget:self action:@selector(microphoneCloseOrOpen:) forControlEvents:UIControlEventTouchUpInside];
        if (GetCore(MeetingCore).isCloseMicro){
            _myButton.selected = YES;
        }
    }
    return _myButton;
}

- (UIButton *)youButton{
    if (!_youButton) {
        _youButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_youButton setBackgroundImage:[UIImage imageNamed:@"game_button_bg"] forState:UIControlStateNormal];
        [_youButton setBackgroundImage:[UIImage imageNamed:@"game_button_bg_ash"] forState:UIControlStateSelected];
        [_youButton setImage:[UIImage imageNamed:@"game_button_volume_on"] forState:UIControlStateNormal];
        [_youButton setImage:[UIImage imageNamed:@"game_button_volume_off"] forState:UIControlStateSelected];
        [_youButton setTitle:@"声音" forState:UIControlStateNormal];
        [_youButton setTitle:@"静音" forState:UIControlStateSelected];
        _youButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_youButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_youButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        _youButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [_youButton addTarget:self action:@selector(voiceCloseOrOpen:) forControlEvents:UIControlEventTouchUpInside];
        if (GetCore(MeetingCore).isMute){
            _youButton.selected = YES;
        }
    }
    return _youButton;
}

- (UIButton *)changeWatchBtn{
    if (!_changeWatchBtn) {
        _changeWatchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeWatchBtn setImage:[UIImage imageNamed:@"game_ChangWatch_left"] forState:UIControlStateNormal];
        [_changeWatchBtn setImage:[UIImage imageNamed:@"game_ChangWatch_right"] forState:UIControlStateSelected];
        [_changeWatchBtn addTarget:self action:@selector(changeWatchActionHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeWatchBtn;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
