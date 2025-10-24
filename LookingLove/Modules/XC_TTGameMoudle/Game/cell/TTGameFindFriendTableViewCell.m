//
//  TTGameFindFriendTableViewCell.m
//  AFNetworking
//
//  Created by new on 2019/4/16.
//

#import "TTGameFindFriendTableViewCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#define kScale(x) ((x) / 375.0 * KScreenWidth)
@interface TTGameFindFriendTableViewCell ()
@property (nonatomic, strong) UIButton *findFriendButton;
@end

@implementation TTGameFindFriendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        
        [self initView];
        
        [self initConstraint];
    }
    return self;
}

- (void)initView{
    [self.contentView addSubview:self.findFriendButton];
}

- (void)initConstraint{
    [self.findFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(kScale(42));
    }];
}

- (void)findFriendAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpFindFriendPage)]) {
        [self.delegate jumpFindFriendPage];
    }
}

- (UIButton *)findFriendButton{
    if (!_findFriendButton) {
        _findFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_findFriendButton setImage:[UIImage imageNamed:@"game_FindFriend"] forState:UIControlStateNormal];
        [_findFriendButton addTarget:self action:@selector(findFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _findFriendButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
