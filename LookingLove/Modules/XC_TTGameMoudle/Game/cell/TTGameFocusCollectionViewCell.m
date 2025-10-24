//
//  TTGameFocusCollectionViewCell.m
//  TTPlay
//
//  Created by new on 2019/3/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameFocusCollectionViewCell.h"

#import "Attention.h"
#import "NSArray+Safe.h"

#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义


@interface TTGameFocusCollectionViewCell ()

@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *roomLabel;

@end

@implementation TTGameFocusCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
        
        [self initView];
        
        [self initConstraint];
    }
    return self;
}

- (void)initView{
    [self.contentView addSubview:self.avatorImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.roomLabel];
}

- (void)initConstraint{
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(53);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.avatorImageView.mas_bottom).offset(6);
    }];
    
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
}

- (void)configData:(NSArray *)array WithIndexPath:(NSInteger )row{
    //    if (row == 0) {
    //        self.titleLabel.hidden = NO;
    //        self.titleLabel.text = @"一起玩";
    //        self.titleLabel.textColor = UIColorFromRGB(0xA49EFE);
    //        self.titleLabel.font = [UIFont systemFontOfSize:14];
    //        self.roomLabel.hidden = YES;
    //        self.avatorImageView.image = [UIImage imageNamed:@"game_findFriend_overlays"];
    //    }else
    if (row == 20) {
        self.titleLabel.hidden = YES;
        self.roomLabel.hidden = YES;
        self.avatorImageView.image = [UIImage imageNamed:@"home_friend_more"];
    }else{
        self.titleLabel.hidden = NO;
        self.roomLabel.hidden = NO;
        self.titleLabel.textColor = [XCTheme getTTMainTextColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        Attention *attention = [array safeObjectAtIndex:row];
        
        [self.avatorImageView qn_setImageImageWithUrl:attention.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:(ImageType)ImageTypeUserIcon];
        
        self.titleLabel.text = attention.nick;
    }
}

- (UIImageView *)avatorImageView{
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.layer.cornerRadius = 53 / 2;
        _avatorImageView.layer.masksToBounds = YES;
    }
    return _avatorImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UILabel *)roomLabel{
    if (!_roomLabel) {
        _roomLabel = [[UILabel alloc] init];
        _roomLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _roomLabel.font = [UIFont systemFontOfSize:11];
        _roomLabel.textAlignment = NSTextAlignmentCenter;
        _roomLabel.text = @"嗨聊中";
    }
    return _roomLabel;
}

@end
