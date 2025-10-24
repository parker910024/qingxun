//
//  TTGameSelectView.m
//  AFNetworking
//
//  Created by User on 2019/4/26.
//

#import "TTGameSelectView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

@interface TTGameSelectView ()

@property (nonatomic, strong) UIImageView *gamePictureImage;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TTGameSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initView];
        
        [self initConstraint];
    }
    
    return self;
}

- (void)initView {
    [self addSubview:self.gamePictureImage];
    
    [self addSubview:self.titleLabel];
}

- (void)initConstraint {
    [self.gamePictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.gamePictureImage.mas_bottom).offset(-11);
        make.left.right.mas_equalTo(self.gamePictureImage);
        make.height.equalTo(@15);
    }];
}

- (void)setModel:(TTCPGameCustomModel *)model {
    [self.gamePictureImage qn_setImageImageWithUrl:model.gameInfo.gameIcon placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:(ImageType)ImageTypeHomePageItem];
    
    self.titleLabel.text = model.gameInfo.gameName;
}

- (void)setGameModel:(CPGameListModel *)gameModel {
    [self.gamePictureImage qn_setImageImageWithUrl:gameModel.gameIcon placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:(ImageType)ImageTypeHomePageItem];
    
    self.titleLabel.text = gameModel.gameName;
}

- (UIImageView *)gamePictureImage {
    if (!_gamePictureImage) {
        _gamePictureImage = [[UIImageView alloc] init];
    }
    return _gamePictureImage;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
