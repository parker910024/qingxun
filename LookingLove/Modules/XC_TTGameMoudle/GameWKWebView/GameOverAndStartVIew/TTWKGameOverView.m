//
//  TTWKGameOverView.m
//  TTPlay
//
//  Created by new on 2019/2/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWKGameOverView.h"
#import "XCTheme.h"
#import "UIView+NTES.h"
#import <YYLabel.h>
#import <YYText.h>
#import "AuthCore.h"
#import "UserCore.h"
#import "MeetingCore.h"
#import "PraiseCore.h"
#import "PraiseCoreClient.h"

#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "TTRibbonsAnimation.h"
#import "UIButton+EnlargeTouchArea.h"
#import "XCHUDTool.h"

#define kScale(x) ((x) / 375.0 * KScreenWidth)

@interface TTWKGameOverView ()

@property (nonatomic, strong) UIView *backView; // 背景
@property (nonatomic, strong) UIImageView *gameBackImageView; // 中间的白色View
@property (nonatomic, strong) UIImageView *gameRelustImageView; // 游戏结束的胜利，失败。平局的VIew
@property (nonatomic, strong) UIImageView *vsImageView;
@property (nonatomic, strong) UIImageView *myImageView; //  我的头像
@property (nonatomic, strong) YYLabel *myNickLabel; // 我的名称

@property (nonatomic, strong) UIImageView *youImageView; // 对方的头像
@property (nonatomic, strong) YYLabel *youNickLabel; // 对方的昵称
@property (nonatomic, strong) UIButton *shareButton; // 分享按钮
@property (nonatomic, strong) AVAudioPlayer *victoryPlayer; // 胜利和失败的音效
@property (nonatomic, strong) NSMutableDictionary *resultData; // 游戏结束返回的data
@property (nonatomic, strong) UIButton *attentionBtn; // 关注按钮
@property (nonatomic, assign) NSInteger attentionID; // 要关注人的id
@property (nonatomic, strong) UIImageView *shareCardImageView; // 分享的提示卡片图片
@end

@implementation TTWKGameOverView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorRGBAlpha(0x000000, 0.65);
        [self initView];
        AddCoreClient(PraiseCoreClient, self);
    }
    
    return self;
}

- (void)dealloc{
    RemoveCore(self);
}

- (void)initView{
    [self addSubview:self.backView];
    [self.backView addSubview:self.gameBackImageView];
    [self.gameBackImageView addSubview:self.shareButton];
    [self.gameBackImageView addSubview:self.shareCardImageView];
    [self.backView addSubview:self.gameRelustImageView];
    [self.gameBackImageView addSubview:self.vsImageView];
    [self.gameBackImageView addSubview:self.myImageView];
    [self.gameBackImageView addSubview:self.myNickLabel];
    [self.gameBackImageView addSubview:self.youImageView];
    [self.gameBackImageView addSubview:self.youNickLabel];
    [self.gameBackImageView addSubview:self.attentionBtn];
}

// setData 赋值
- (void)setDataDict:(NSDictionary *)dataDict{
    
    self.resultData = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    
    if ([self.superViewType isEqualToString:@"privateChat"] || [self.superViewType isEqualToString:@"room"]) {
        [self.backView addSubview:self.ageinGameButton];
        [self.backView addSubview:self.changeGameButton];
        [self.backView addSubview:self.backButton];
    }else{
        [self.backView addSubview:self.ageinGameButton];
        [self.backView addSubview:self.changeGameButton];
        [self.backView addSubview:self.changePeopleButton];
        [self.backView addSubview:self.backButton];
    }
    
    if ([dataDict[@"resultType"] isEqualToString:@"not_draw"]) {
        if ([[dataDict[@"winners"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
            self.gameRelustImageView.image = [UIImage imageNamed:@"room_cp_game_victory"];
            
            NSURL *musicUrlString = [[NSBundle mainBundle] URLForResource:@"win" withExtension:@"wav"];
            
            self.victoryPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrlString error:nil];
            [self.victoryPlayer play];
            
            [TTRibbonsAnimation show];
        }else{
            self.gameRelustImageView.image = [UIImage imageNamed:@"room_cp_game_defeated"];
            
            NSURL *faileUrl = [[NSBundle mainBundle] URLForResource:@"lose" withExtension:@"mp3"];
            
            self.victoryPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:faileUrl error:nil];
            [self.victoryPlayer play];

        }
    }else{
        self.gameRelustImageView.image = [UIImage imageNamed:@"room_cp_game_draw"];
    }
    
    if ([[dataDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] == GetCore(AuthCore).getUid.userIDValue) {
        
        [[GetCore(UserCore) getUserInfoByRac:[[dataDict[@"users"] safeObjectAtIndex:1][@"uid"] userIDValue] refresh:NO] subscribeNext:^(id x) {
            
            UserInfo *info = x;
            
            [self.youImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            
            self.youNickLabel.attributedText = [self createNickAttributeString:info.nick Gender:info.gender];
            [self.youNickLabel sizeToFit];
            self.youNickLabel.centerX = self.youImageView.centerX;
            
            [GetCore(PraiseCore) isUid:GetCore(AuthCore).getUid.userIDValue isLikeUid:[[dataDict[@"users"] safeObjectAtIndex:1][@"uid"] userIDValue] success:^(BOOL isLike) {
                if (isLike) {
                    self.attentionBtn.hidden = YES;
                }else{
                    self.attentionBtn.hidden = NO;
                    self.attentionID = [[dataDict[@"users"] safeObjectAtIndex:1][@"uid"] userIDValue];
                }
            }];
        }];
        
    }else{
        [[GetCore(UserCore) getUserInfoByRac:[[dataDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] refresh:NO] subscribeNext:^(id x) {
            
            UserInfo *info = x;
            
            [self.youImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            
            self.youNickLabel.attributedText = [self createNickAttributeString:info.nick Gender:info.gender];
            [self.youNickLabel sizeToFit];
            self.youNickLabel.centerX = self.youImageView.centerX;
            
            [GetCore(PraiseCore) isUid:GetCore(AuthCore).getUid.userIDValue isLikeUid:[[dataDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue] success:^(BOOL isLike) {
                if (isLike) {
                    self.attentionBtn.hidden = YES;
                }else{
                    self.attentionBtn.hidden = NO;
                    self.attentionID = [[dataDict[@"users"] safeObjectAtIndex:0][@"uid"] userIDValue];
                }
            }];
        }];
    }
    
}


#pragma mark --- button 点击方法  ---
// 再来一局
- (void)againButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(againGameActionHander)]) {
        [self.delegate againGameActionHander];
    }
}

// 换个游戏
- (void)changeGameButtonAction:(UIButton *)sender{
    
    if ([self.superViewType isEqualToString:@"privateChat"] || [self.superViewType isEqualToString:@"publicChat"]) {
        [GetCore(MeetingCore) leaveMeeting:self.resultData[@"roomId"]];
        [GetCore(MeetingCore) setCloseMicro:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changGameActionHander)]) {
        [self.delegate changGameActionHander];
    }
    
}

// 换个对手
- (void)changePepleButtonAction:(UIButton *)sender{
    
    if ([self.superViewType isEqualToString:@"privateChat"] || [self.superViewType isEqualToString:@"publicChat"]) {
        [GetCore(MeetingCore) leaveMeeting:self.resultData[@"roomId"]];
        [GetCore(MeetingCore) setCloseMicro:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePeopleActionHander)]) {
        [self.delegate changePeopleActionHander];
    }
    
}

// 返回
- (void)backButtonAction:(UIButton *)sender{
    
    if ([self.superViewType isEqualToString:@"privateChat"] || [self.superViewType isEqualToString:@"publicChat"]) {
        [GetCore(MeetingCore) leaveMeeting:self.resultData[@"roomId"]];
        [GetCore(MeetingCore) setCloseMicro:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(backMainPageAciton)]) {
        [self.delegate backMainPageAciton];
    }
}

// 分享
- (void)shareButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareGameResultAction)]) {
        [self.delegate shareGameResultAction];
    }
}

- (void)onPraiseSuccess:(UserID)uid {
    [XCHUDTool showSuccessWithMessage:@"关注成功，相互关注可成为好友哦"];
}

// 关注
- (void)attentionButtonAction:(UIButton *)sender{
    [GetCore(PraiseCore) praise:GetCore(AuthCore).getUid.userIDValue bePraisedUid:self.attentionID];
    sender.hidden = YES;
}

#pragma mark --- setter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.left = 0;
        _backView.width = KScreenWidth;
        _backView.backgroundColor = UIColor.clearColor;
    }
    return _backView;
}

- (UIImageView *)gameBackImageView{
    if (!_gameBackImageView) {
        _gameBackImageView = [[UIImageView alloc] init];
        _gameBackImageView.clipsToBounds = NO;
        _gameBackImageView.image = [UIImage imageNamed:@"game_results_bg"];
        _gameBackImageView.top = kScale(153);
        _gameBackImageView.size = CGSizeMake(kScale(300), kScale(190));
        _gameBackImageView.centerX = KScreenWidth / 2;
        _gameBackImageView.userInteractionEnabled = YES;
    }
    return _gameBackImageView;
}

- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.size = CGSizeMake(kScale(17), kScale(17));
        [_shareButton setImage:[UIImage imageNamed:@"game_results_share"] forState:UIControlStateNormal];
        _shareButton.right = self.gameBackImageView.width - 11;
        _shareButton.top = 11;
        [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    }
    return _shareButton;
}

- (UIImageView *)shareCardImageView{
    if (!_shareCardImageView) {
        _shareCardImageView = [[UIImageView alloc] init];
        _shareCardImageView.size = CGSizeMake(115, 24);
        _shareCardImageView.image = [UIImage imageNamed:@"share_result_hint"];
        _shareCardImageView.right = self.gameBackImageView.width - kScale(33);
        _shareCardImageView.top = kScale(25);
    }
    return _shareCardImageView;
}

- (UIImageView *)gameRelustImageView{
    if (!_gameRelustImageView) {
        _gameRelustImageView = [[UIImageView alloc] init];
        _gameRelustImageView.top = kScale(55);
        _gameRelustImageView.size = CGSizeMake(kScale(204), kScale(116));
        _gameRelustImageView.centerX = KScreenWidth / 2;
    }
    return _gameRelustImageView;
}

- (UIImageView *)vsImageView{
    if (!_vsImageView) {
        _vsImageView = [[UIImageView alloc] init];
        _vsImageView.image = [UIImage imageNamed:@"VS"];
        _vsImageView.size = CGSizeMake(27, 18);
        _vsImageView.centerX = self.gameBackImageView.width / 2;
        _vsImageView.centerY = self.gameBackImageView.height / 2 - 15 / 2;
    }
    return _vsImageView;
}

- (UIImageView *)myImageView{
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] init];
        _myImageView.size = CGSizeMake(74, 74);
        _myImageView.centerY = _vsImageView.centerY;
        _myImageView.layer.cornerRadius = _myImageView.width / 2;
        _myImageView.layer.masksToBounds = YES;
        _myImageView.right = _vsImageView.left - 23;
        [_myImageView qn_setImageImageWithUrl:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    }
    return _myImageView;
}

- (YYLabel *)myNickLabel{
    if (!_myNickLabel) {
        _myNickLabel = [[YYLabel alloc] init];
        _myNickLabel.attributedText = [self createNickAttributeString:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick Gender:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].gender];
        _myNickLabel.font = [UIFont systemFontOfSize:14];
        [_myNickLabel sizeToFit];
        _myNickLabel.top = _myImageView.bottom + 10;
        _myNickLabel.centerX = _myImageView.centerX;
        _myNickLabel.height = 15;
        
    }
    return _myNickLabel;
}

- (UIImageView *)youImageView{
    if (!_youImageView) {
        _youImageView = [[UIImageView alloc] init];
        _youImageView.size = CGSizeMake(74, 74);
        _youImageView.centerY = _vsImageView.centerY;
        _youImageView.layer.cornerRadius = _youImageView.width / 2;
        _youImageView.layer.masksToBounds = YES;
        _youImageView.left = _vsImageView.right + 23;
    }
    return _youImageView;
}

- (YYLabel *)youNickLabel{
    if (!_youNickLabel) {
        _youNickLabel = [[YYLabel alloc] init];
        _youNickLabel.top = _youImageView.bottom + 10;
        _youNickLabel.centerX = _youImageView.centerX;
        _youNickLabel.height = 15;
        _youNickLabel.font = [UIFont systemFontOfSize:14];
    }
    return _youNickLabel;
}

- (UIButton *)attentionBtn{
    if (!_attentionBtn) {
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _attentionBtn.backgroundColor = UIColorFromRGB(0xFFB606);
        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _attentionBtn.layer.cornerRadius = 12;
        _attentionBtn.size = CGSizeMake(65, 24);
        _attentionBtn.top = _youNickLabel.bottom + kScale(10);
        _attentionBtn.centerX = _youNickLabel.centerX;
        _attentionBtn.hidden = YES;
        [_attentionBtn addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

- (UIButton *)ageinGameButton{
    if (!_ageinGameButton) {
        _ageinGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ageinGameButton.size = CGSizeMake(kScale(260), kScale(44));
        _ageinGameButton.layer.cornerRadius = _ageinGameButton.height / 2;
        _ageinGameButton.backgroundColor = UIColorFromRGB(0xFFB606);
        _ageinGameButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_ageinGameButton setTitle:@"再来一局" forState:UIControlStateNormal];
        [_ageinGameButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _ageinGameButton.top = self.gameBackImageView.bottom + kScale(28);
        _ageinGameButton.centerX = KScreenWidth / 2;
        [_ageinGameButton addTarget:self action:@selector(againButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ageinGameButton;
}


- (UIButton *)changeGameButton{
    if (!_changeGameButton) {
        _changeGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeGameButton.size = CGSizeMake(kScale(260), kScale(44));
        _changeGameButton.layer.cornerRadius = _changeGameButton.height / 2;
        _changeGameButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _changeGameButton.backgroundColor = UIColor.clearColor;
        _changeGameButton.layer.borderWidth = 2;
        _changeGameButton.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        [_changeGameButton setTitle:@"换个游戏" forState:UIControlStateNormal];
        [_changeGameButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _changeGameButton.top = self.ageinGameButton.bottom + kScale(18);
        _changeGameButton.centerX = KScreenWidth / 2;
        [_changeGameButton addTarget:self action:@selector(changeGameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeGameButton;
}

- (UIButton *)changePeopleButton{
    if (!_changePeopleButton) {
        _changePeopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changePeopleButton.size = CGSizeMake(kScale(260), kScale(44));
        _changePeopleButton.layer.cornerRadius = _changePeopleButton.height / 2;
        _changePeopleButton.backgroundColor = UIColor.clearColor;
        _changePeopleButton.layer.borderWidth = 2;
        _changePeopleButton.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        [_changePeopleButton setTitle:@"换个对手" forState:UIControlStateNormal];
        [_changePeopleButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _changePeopleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _changePeopleButton.top = self.changeGameButton.bottom + kScale(18);
        _changePeopleButton.centerX = KScreenWidth / 2;
        [_changePeopleButton addTarget:self action:@selector(changePepleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changePeopleButton;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_backButton sizeToFit];
        if ([self.superViewType isEqualToString:@"privateChat"]) {
            _backButton.top = self.changeGameButton.bottom + kScale(28);
        }else{
            _backButton.top = self.changePeopleButton.bottom + kScale(28);
        }
        _backButton.centerX = KScreenWidth / 2;
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _backView.height = _backButton.bottom;
        _backView.centerY = KScreenHeight / 2 - kScale(40);
    }
    return _backButton;
}

//create mic+nick+gender
- (NSMutableAttributedString *)createNickAttributeString:(NSString *)nickString Gender:(UserGender )gender{
    CGFloat fontSize = 14.0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    //nick
    NSMutableAttributedString *nickLabelString = [self createNickLabel:nickString fontSize:fontSize];
    
    //gender
    NSMutableAttributedString *genderString = [self createGenderAttr:gender];
    
    
    [attributedString appendAttributedString:nickLabelString];
    [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    [attributedString appendAttributedString:genderString];
    
    return attributedString;
}

- (NSMutableAttributedString *)createNickLabel:(NSString *)userNick fontSize:(CGFloat)fontSize{
    
    UILabel *nickLabel = [[UILabel alloc]init];
    //text
    NSString *nick = userNick;
    
    nickLabel.text = nick;
    
    nickLabel.font = [UIFont systemFontOfSize:fontSize];
    
    nickLabel.textColor = UIColorRGBAlpha(0x333333, 1.0);
    
    //width
    CGFloat nickWidth = [self sizeWithText:nick font:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(KScreenWidth , KScreenHeight)].width;
    CGFloat maxWidth = 72;
    if (nickWidth > maxWidth) {
        nickLabel.bounds = CGRectMake(0, 0, maxWidth, 14);
    }else {
        nickLabel.bounds = CGRectMake(0, 0, nickWidth+3, 14);
    }
    
    NSMutableAttributedString * nickString = [NSMutableAttributedString yy_attachmentStringWithContent:nickLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nickLabel.frame.size.width, nickLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:fontSize] alignment:YYTextVerticalAlignmentCenter];
    return nickString;
}

//create gender
- (NSMutableAttributedString *)createGenderAttr:(UserGender )gender{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.bounds = CGRectMake(0, 0, 14, 14);;
    imageView.contentMode = UIViewContentModeScaleToFill;
    NSString *imageName = @"";
    if (gender == 1) {
        imageName = @"game_gender_boy";
    }else{
        imageName = @"game_gender_girl";
    }
    imageView.image = [UIImage imageNamed:imageName];
    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
    return imageString;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
