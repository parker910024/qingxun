//
//  XC_MSContributionChampiomView.m
//  AFNetworking
//
//  Created by zoey on 2019/2/12.
//

#import "TTRoomContributionCrownView.h"

//cate
#import "UIImage+Utils.h"
//t
#import "XCTheme.h"
#import "Masonry.h"

@interface TTRoomContributionCrownView()
@property (nonatomic, strong) UIImageView *avatarBGImageView;//头像背景

@property (nonatomic, assign) TTRoomContributionCrownType crownType;

@end

@implementation TTRoomContributionCrownView

- (instancetype)initWithChampiomPostion:(TTRoomContributionCrownType)champiomPostion contributionType:(TTRoomContributionType)contributionType {
    
    self = [super init];
    if (self) {
        self.crownType = champiomPostion;
        self.showAvatarPlaceholder = YES;
    
        [self initSubView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectdAvatar)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)initSubView {
    [self addSubview:self.avatarImageView];
    [self addSubview:self.avatarBGImageView];
    
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.avatarBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    CGFloat width = self.crownType == TTRoomContributionCrownTypeFirst ? 73 : 59;
    self.avatarImageView.layer.cornerRadius = width/2.0;
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.avatarBGImageView).offset(-7.5);
        make.centerX.mas_equalTo(self.avatarBGImageView);
        make.width.height.mas_equalTo(width);
    }];
}

- (void)selectdAvatar {
    if (self.uid == 0) {
        return;
    }
    
    !self.selectedBlock ?: self.selectedBlock(self.uid);
}

- (void)setupAvatarBGImage {
    
    NSMutableString *bgImage = [[NSMutableString alloc] init];
    if (self.crownType == TTRoomContributionCrownTypeFirst) {
        [bgImage appendString:@"room_contribution_avatar_first"];
    } else if (self.crownType == TTRoomContributionCrownTypeSecond) {
        [bgImage appendString:@"room_contribution_avatar_second"];
    } else {
        [bgImage appendString:@"room_contribution_avatar_third"];
    }
    
    if (self.showAvatarPlaceholder) {
        [bgImage appendString:@"_placeholder"];
    }
    
    self.avatarBGImageView.image = [UIImage imageNamed:bgImage];
}

#pragma mark - Getter && Setter
- (void)setShowAvatarPlaceholder:(BOOL)showAvatarPlaceholder {
    _showAvatarPlaceholder = showAvatarPlaceholder;
    
    [self setupAvatarBGImage];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)avatarBGImageView {
    if (!_avatarBGImageView) {
        _avatarBGImageView = [[UIImageView alloc] init];
    }
    return _avatarBGImageView;
}

@end
