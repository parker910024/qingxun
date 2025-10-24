//
//  TTCustomMatchView.m
//  TTPlay
//
//  Created by new on 2019/4/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCustomMatchView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import <YYText.h>
#import <YYLabel.h>

#import "AuthCore.h"
#import "UserCore.h"

@interface TTCustomMatchView ()

@property (nonatomic, strong) UIImageView *effectImageView;
@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) YYLabel *myNickLabel;
@property (nonatomic, strong) YYLabel *youNickLabel;
@end

@implementation TTCustomMatchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        
        [self initView];
        
        [self initConstraint];
    }
    return self;
}


- (void)initView{
    [self addSubview:self.effectImageView];
    [self addSubview:self.avatorImageView];
    [self addSubview:self.myNickLabel];
}

- (void)initConstraint{
    [self.effectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 120));
        make.center.mas_equalTo(self);
    }];
    
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.center.mas_equalTo(self);
    }];
    
    [self.myNickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatorImageView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(14);
    }];
}

- (void)setImageUrlString:(NSString *)imageUrlString{
    [self.avatorImageView qn_setImageImageWithUrl:imageUrlString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
}

- (void)setUserID:(UserID)userID{
    [UIView animateWithDuration:0.4 animations:^{
        self.myNickLabel.alpha = 1;
    }];
    if (userID != GetCore(AuthCore).getUid.userIDValue) {
        [[GetCore(UserCore) getUserInfoByRac:userID refresh:NO] subscribeNext:^(id x) {
            UserInfo *info = (UserInfo *)x;
            self.myNickLabel.attributedText = [self createNickAttributeString:info.nick Gender:info.gender];
            [self.myNickLabel sizeToFit];
        }];
    }else{
        self.myNickLabel.attributedText = [self createNickAttributeString:[GetCore(UserCore) getUserInfoInDB:userID].nick Gender:[GetCore(UserCore) getUserInfoInDB:userID].gender];
        [self.myNickLabel sizeToFit];
    }
}

- (void)startAnimation{
    [UIView beginAnimations:@"UIViewAnimation" context:(__bridge void *)(self)];
    
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelay:0.0];
    
    [UIView setAnimationRepeatCount:INT_MAX];
    [UIView setAnimationRepeatAutoreverses:YES];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    self.effectImageView.alpha = 1;
    
    [UIView commitAnimations];
}


#pragma mark -- 生成名字性别富文本 ---
//create mic+nick+gender
- (NSMutableAttributedString *)createNickAttributeString:(NSString *)nickString Gender:(UserGender )gender{
    CGFloat fontSize = 14.0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    //nick
    NSMutableAttributedString *nickLabelString = [self createNickLabel:nickString fontSize:fontSize];
    
    //gender
    NSMutableAttributedString *genderString = [self createGenderAttr:gender];
    
    
    [attributedString appendAttributedString:nickLabelString];
    //    [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    [attributedString appendAttributedString:genderString];
    
    return attributedString;
}

- (NSMutableAttributedString *)createNickLabel:(NSString *)userNick fontSize:(CGFloat)fontSize{
    
    UILabel *nickLabel = [[UILabel alloc]init];
    //text
    NSString *nick = userNick;
    
    nickLabel.text = nick;
    
    nickLabel.font = [UIFont systemFontOfSize:fontSize];
    
    nickLabel.textColor = UIColorRGBAlpha(0xFFFFFF, 1.0);
    
    //width
    CGFloat nickWidth = [self sizeWithText:nick font:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(KScreenWidth , KScreenHeight)].width;
    CGFloat maxWidth = 76;
    if (nickWidth > maxWidth) {
        nickLabel.bounds = CGRectMake(0, 0, maxWidth, 14);
    }else {
        nickLabel.bounds = CGRectMake(0, 0, nickWidth + 3, 14);
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

#pragma mark -- setter ---
- (UIImageView *)effectImageView{
    if (!_effectImageView) {
        _effectImageView = [[UIImageView alloc] init];
        _effectImageView.image = [UIImage imageNamed:@"game_avatorLightingEffect"];
        _effectImageView.alpha = 0;
    }
    return _effectImageView;
}

- (UIImageView *)avatorImageView{
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.layer.cornerRadius = 40;
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.borderWidth = 4;
        _avatorImageView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    }
    return _avatorImageView;
}

-(YYLabel *)myNickLabel{
    if (!_myNickLabel) {
        _myNickLabel = [[YYLabel alloc] init];
        _myNickLabel.font = [UIFont systemFontOfSize:14];
        _myNickLabel.alpha = 0;
    }
    return _myNickLabel;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
