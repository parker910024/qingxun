//
//  TTSelectGameView.m
//  AFNetworking
//
//  Created by new on 2019/4/15.
//

#import "TTSelectGameView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

#import "CPGameCore.h"
#import "CPGameCoreClient.h"
#import "CPGameListModel.h"
#import "AuthCore.h"
#import "TTGameStaticTypeCore.h"
#import <UIButton+WebCache.h>
#import "TTCPGameStaticCore.h"

@interface TTSelectGameView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *clostButton;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSMutableArray *datasourceArray;

@end

@implementation TTSelectGameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorRGBAlpha(0xf5f5f5, 1);

        [self initView];
        
        [self initConstraint];
        
        [self addCore];
    }
    return self;
}


- (void)initView {
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.titleLabel];
    [self.backImageView addSubview:self.centerButton];
    [self.backImageView addSubview:self.leftButton];
    [self.backImageView addSubview:self.rightButton];
    [self.backImageView addSubview:self.clostButton];
    
    [self.btnArray addObject:self.leftButton];
    [self.btnArray addObject:self.centerButton];
    [self.btnArray addObject:self.rightButton];
}

- (void)initConstraint {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 163));
        make.top.mas_equalTo(7);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.centerX.mas_equalTo(self.backImageView);
    }];
    
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 72));
        make.centerX.mas_equalTo(self.backImageView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 72));
        make.right.mas_equalTo(self.centerButton.mas_left).offset(-12);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 72));
        make.left.mas_equalTo(self.centerButton.mas_right).offset(12);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
    }];
    
    [self.clostButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-22.5);
    }];
}

- (void)addCore {
    AddCoreClient(CPGameCoreClient, self);
}

- (void)btnClickWithModel:(CPGameListModel *)model {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnClickLaunchGameWithModel:)]) {
        [self.delegate btnClickLaunchGameWithModel:model];
    }
}

- (void)leftBtnAction:(UIButton *)sender {
    CPGameListModel *model = [self.datasourceArray safeObjectAtIndex:(sender.tag - 100)];
    [self btnClickWithModel:model];
}

- (void)centerBtnAction:(UIButton *)sender {
    CPGameListModel *model = [self.datasourceArray safeObjectAtIndex:(sender.tag - 100)];
    [self btnClickWithModel:model];
}

- (void)rightBtnAction:(UIButton *)sender {
    CPGameListModel *model = [self.datasourceArray safeObjectAtIndex:(sender.tag - 100)];
    [self btnClickWithModel:model];
}

- (void)clostBtnAction:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeSelectGameView)]) {
        [self.delegate removeSelectGameView];
    }
}

- (void)setUserUid:(NSString *)userUid {
    [self requestDataWithUid:userUid];
}

- (void)requestDataWithUid:(NSString *)uid {
    [GetCore(CPGameCore) requestGetUserFavoriteGameWithUid:uid.userIDValue];
}

- (void)findFriendMatchMessageUserFavoriteGame:(NSArray *)listArray {
    [self.datasourceArray addObjectsFromArray:listArray];
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = [self.datasourceArray safeObjectAtIndex:i];
        UIButton *button = [self.btnArray safeObjectAtIndex:i];
        [button sd_setImageWithURL:[NSURL URLWithString:model.gamePicture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_avatar]]];
    }
    switch (self.datasourceArray.count) {
        case 1:{
            [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(72, 72));
                make.centerX.mas_equalTo(self.backImageView);
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
            }];
            break;
        }
        case 2:{
            [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(72, 72));
                make.right.mas_equalTo(self.backImageView.mas_centerX).offset(-10);
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
            }];
            
            [self.centerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(72, 72));
                make.left.mas_equalTo(self.backImageView.mas_centerX).offset(10);
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
            }];
            break;
        }
        case 3:{
         
            break;
        }
        default:
            break;
    }
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"messageChat_popup_game_bg"];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTSubTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = @"Ta爱玩的游戏";
    }
    return _titleLabel;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.tag = 100;
    }
    return _leftButton;
}

- (UIButton *)centerButton{
    if (!_centerButton) {
        _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerButton addTarget:self action:@selector(centerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _centerButton.tag = 101;
    }
    return _centerButton;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.tag = 102;
    }
    return _rightButton;
}

- (UIButton *)clostButton{
    if (!_clostButton) {
        _clostButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clostButton setImage:[UIImage imageNamed:@"messageChat_popup_game_close_slices"] forState:UIControlStateNormal];
        [_clostButton addTarget:self action:@selector(clostBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clostButton;
}

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (NSMutableArray *)datasourceArray{
    if (!_datasourceArray) {
        _datasourceArray = [NSMutableArray array];
    }
    return _datasourceArray;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
