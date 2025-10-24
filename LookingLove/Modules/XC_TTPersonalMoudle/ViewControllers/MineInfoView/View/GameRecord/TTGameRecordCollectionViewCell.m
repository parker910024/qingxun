//
//  TTGameRecordCollectionViewCell.m
//  TTPlay
//
//  Created by new on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRecordCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"

@interface TTGameRecordCollectionViewCell ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *tagImageView;

@end

@implementation TTGameRecordCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.backImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.tagImageView];
        
        [self initConstrations];
    }
    return self;
}

- (void)configModel:(TTMineGameListModel *)model{
    
    [self.backImageView qn_setImageImageWithUrl:model.gamePicture placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:(ImageType)ImageTypeHomePageItem];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%lld胜",model.winCount];
    
    if (model.first) {
        self.tagImageView.hidden = NO;
    }else{
        self.tagImageView.hidden = YES;
    }
    
}

//- (void)configModel:(NSArray *)array WithIndexPathRow:(NSInteger )row{
//
//    [self.backImageView qn_setImageImageWithUrl:array[row] placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:(ImageType)ImageTypeHomePageItem];
//
//    self.titleLabel.text = @"200胜";
//
//    if (row == 0) {
//        self.tagImageView.hidden = NO;
//    }else{
//        self.tagImageView.hidden = YES;
//    }
//}



- (void)initConstrations{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView.mas_bottom).offset(9);
        make.height.mas_equalTo(15);
        make.centerX.mas_equalTo(self.backImageView);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}




-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.layer.cornerRadius = 10;
        _backImageView.layer.masksToBounds = YES;
    }
    return _backImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getMSSecondTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

-(UIImageView *)tagImageView{
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.image = [UIImage imageNamed:@"mineInfo_tag_game_top"];
        _tagImageView.hidden = YES;
    }
    return _tagImageView;
}

@end
