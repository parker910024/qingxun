//
//  XC_MSBaseContributionHeadView.m
//  AFNetworking
//
//  Created by zoey on 2019/2/12.
//

#import "TTBaseContributionTableHeaderView.h"
//view
#import "TTRoomContributionCrownInfoView.h"
#import "TTRoomContributionCrownView.h"

//model
#import "RankData.h"
#import "RoomBounsListInfo.h"
//cate
#import "UIImageView+QiNiu.h"
#import "NSArray+Safe.h"
#import "NSString+SpecialClean.h"

//t
#import "BaseAttrbutedStringHandler.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTBaseContributionTableHeaderView()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) TTRoomContributionCrownView *firstAvatarView;
@property (nonatomic, strong) TTRoomContributionCrownView *secondAvatarView;
@property (nonatomic, strong) TTRoomContributionCrownView *thirdAvatarView;

@property (nonatomic, strong) TTRoomContributionCrownInfoView *firstInfoView;
@property (nonatomic, strong) TTRoomContributionCrownInfoView *secondInfoView;
@property (nonatomic, strong) TTRoomContributionCrownInfoView *thirdInfoView;
@end

@implementation TTBaseContributionTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    [self addSubview:self.bgImageView];
    [self addSubview:self.firstAvatarView];
    [self addSubview:self.secondAvatarView];
    [self addSubview:self.thirdAvatarView];
    
    [self addSubview:self.firstInfoView];
    [self addSubview:self.secondInfoView];
    [self addSubview:self.thirdInfoView];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    CGFloat unitCellWidth = (KScreenWidth-15*2)/3.0;
    
    [self.firstAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(100);
    }];
    [self.secondAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(40);
        make.centerX.mas_equalTo(self).offset(-unitCellWidth);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(84);
    }];
    [self.thirdAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(40);
        make.centerX.mas_equalTo(self).offset(unitCellWidth);
        make.width.height.mas_equalTo(self.secondAvatarView);
    }];
    
    [self.firstInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstAvatarView.mas_bottom).offset(13);
        make.centerX.mas_equalTo(self.firstAvatarView);
        make.width.mas_equalTo(unitCellWidth);
        make.height.mas_equalTo(60);
    }];
    [self.secondInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.secondAvatarView.mas_bottom).offset(13);
        make.centerX.mas_equalTo(self.secondAvatarView);
        make.size.mas_equalTo(self.firstInfoView);
    }];
    [self.thirdInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.thirdAvatarView.mas_bottom).offset(13);
        make.centerX.mas_equalTo(self.thirdAvatarView);
        make.size.mas_equalTo(self.firstInfoView);
    }];
}

#pragma makr - private

///填充第一名的头像和数据
- (void)setupFirstRank:(RankData *)data {
    
    BOOL notData = data == nil;
    self.firstAvatarView.showAvatarPlaceholder = notData;
    self.firstAvatarView.uid = data.uid;
    [self.firstAvatarView.avatarImageView qn_setImageImageWithUrl:data.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];

    if (notData) {
        self.firstInfoView.nameLabel.text = @"虚位以待";
        self.firstInfoView.uidLabel.text = nil;
        self.firstInfoView.accountLabel.text = nil;
        return;
    }
    
    NSString *name = self.type == TTRoomContributionTypeHalfhour ? data.roomTitle : data.nick;
    self.firstInfoView.nameLabel.text = name;
    
    NSString *uid = [NSString stringWithFormat:@"ID:%@", data.erbanNo];
    self.firstInfoView.uidLabel.text = uid;
    
    self.firstInfoView.accountLabel.text = @"NO.1";
    if (self.type == TTRoomContributionTypeInRoom) {
        NSString *totalNum = [self accountCalculate:data.totalNum.integerValue];
        self.firstInfoView.accountLabel.text = totalNum;
    }
    
    self.firstInfoView.genderImageView.hidden = self.type == TTRoomContributionTypeHalfhour;
    self.firstInfoView.genderImageView.image = [UIImage imageNamed:data.gender == UserInfo_Male ? @"common_sex_male" : @"common_sex_female"];
}

///填充第二名的头像和数据
- (void)setupSecondRank:(RankData *)data {
    
    BOOL notData = data == nil;
    self.secondAvatarView.showAvatarPlaceholder = notData;
    self.secondAvatarView.uid = data.uid;
    [self.secondAvatarView.avatarImageView qn_setImageImageWithUrl:data.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];

    if (notData) {
        self.secondInfoView.nameLabel.text = @"虚位以待";
        self.secondInfoView.uidLabel.text = nil;
        self.secondInfoView.accountLabel.text = nil;
        return;
    }
    
    NSString *name = self.type == TTRoomContributionTypeHalfhour ? data.roomTitle : data.nick;
    self.secondInfoView.nameLabel.text = name;
    
    NSString *uid = [NSString stringWithFormat:@"ID:%@", data.erbanNo];
    self.secondInfoView.uidLabel.text = uid;
    
    BOOL isHalfhourType = self.type == TTRoomContributionTypeHalfhour;
    NSString *accountDes = isHalfhourType ? @"距前一名 " : @"";//半小时榜流水前有 “距前一名”
    NSString *totalNum = [self accountCalculate:data.totalNum.integerValue];
    NSString *account = [NSString stringWithFormat:@"%@%@", accountDes, totalNum];
    self.secondInfoView.accountLabel.text = account;
    
    self.secondInfoView.genderImageView.hidden = self.type == TTRoomContributionTypeHalfhour;
    self.secondInfoView.genderImageView.image = [UIImage imageNamed:data.gender == UserInfo_Male ? @"common_sex_male" : @"common_sex_female"];
}

///填充第三名的头像和数据
- (void)setupThirdRank:(RankData *)data {
    
    BOOL notData = data == nil;
    self.thirdAvatarView.showAvatarPlaceholder = notData;
    self.thirdAvatarView.uid = data.uid;
    [self.thirdAvatarView.avatarImageView qn_setImageImageWithUrl:data.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    
    if (notData) {
        self.thirdInfoView.nameLabel.text = @"虚位以待";
        self.thirdInfoView.uidLabel.text = nil;
        self.thirdInfoView.accountLabel.text = nil;
        return;
    }
    
    NSString *name = self.type == TTRoomContributionTypeHalfhour ? data.roomTitle : data.nick;
    self.thirdInfoView.nameLabel.text = name;
    
    NSString *uid = [NSString stringWithFormat:@"ID:%@", data.erbanNo];
    self.thirdInfoView.uidLabel.text = uid;
    
    BOOL isHalfhourType = self.type == TTRoomContributionTypeHalfhour;
    NSString *accountDes = isHalfhourType ? @"距前一名 " : @"";//半小时榜流水前有 “距前一名”
    NSString *totalNum = [self accountCalculate:data.totalNum.integerValue];
    NSString *account = [NSString stringWithFormat:@"%@%@", accountDes, totalNum];
    self.thirdInfoView.accountLabel.text = account;
    
    self.thirdInfoView.genderImageView.hidden = self.type == TTRoomContributionTypeHalfhour;
    self.thirdInfoView.genderImageView.image = [UIImage imageNamed:data.gender == UserInfo_Male ? @"common_sex_male" : @"common_sex_female"];
}

/**
 流水显示计算，过万时显示 xx万
 */
- (NSString *)accountCalculate:(NSInteger)totalNum {
    if (totalNum < 10000) {
        return @(totalNum).stringValue;
    }
    
    return [NSString stringWithFormat:@"%.2f万", totalNum/10000.0];
}

#pragma mark - Getter && Setter
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    RankData *firstRank = [dataArray safeObjectAtIndex:0];
    RankData *secondRank = [dataArray safeObjectAtIndex:1];
    RankData *thirdRank = [dataArray safeObjectAtIndex:2];
    
    [self setupFirstRank:firstRank];
    [self setupSecondRank:secondRank];
    [self setupThirdRank:thirdRank];
}

- (void)setType:(TTRoomContributionType)type {
    _type = type;
    
    if (_type == TTRoomContributionTypeHalfhour) {
        self.bgImageView.image = [UIImage imageNamed:@"room_contribution_bg_halfhour_bottom"];
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"room_contribution_bg_inRoom_bottom"];
    }
}

- (TTRoomContributionCrownView *)firstAvatarView {
    if (!_firstAvatarView) {
        _firstAvatarView = [[TTRoomContributionCrownView alloc] initWithChampiomPostion:TTRoomContributionCrownTypeFirst contributionType:self.type];
        @weakify(self)
        _firstAvatarView.selectedBlock = ^(UserID uid) {
            @strongify(self)
            !self.selectedBlcok?:self.selectedBlcok(uid);
        };
    }
    return _firstAvatarView;
}

- (TTRoomContributionCrownView *)secondAvatarView {
    if (!_secondAvatarView) {
        _secondAvatarView = [[TTRoomContributionCrownView alloc] initWithChampiomPostion:TTRoomContributionCrownTypeSecond contributionType:self.type];
        @weakify(self)
        _secondAvatarView.selectedBlock = ^(UserID uid) {
            @strongify(self)
            !self.selectedBlcok?:self.selectedBlcok(uid);
        };
    }
    return _secondAvatarView;
}

- (TTRoomContributionCrownView *)thirdAvatarView {
    if (!_thirdAvatarView) {
        _thirdAvatarView = [[TTRoomContributionCrownView alloc] initWithChampiomPostion:TTRoomContributionCrownTypeThird contributionType:self.type];
        @weakify(self)
        _thirdAvatarView.selectedBlock = ^(UserID uid) {
            @strongify(self)
            !self.selectedBlcok?:self.selectedBlcok(uid);
        };
    }
    return _thirdAvatarView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (TTRoomContributionCrownInfoView *)firstInfoView {
    if (!_firstInfoView) {
        _firstInfoView = [[TTRoomContributionCrownInfoView alloc] init];
    }
    return _firstInfoView;
}

- (TTRoomContributionCrownInfoView *)secondInfoView {
    if (!_secondInfoView) {
        _secondInfoView = [[TTRoomContributionCrownInfoView alloc] init];
    }
    return _secondInfoView;
}

- (TTRoomContributionCrownInfoView *)thirdInfoView {
    if (!_thirdInfoView) {
        _thirdInfoView = [[TTRoomContributionCrownInfoView alloc] init];
    }
    return _thirdInfoView;
}

@end
