//
//  TTGameRankTableViewCell.m
//  TTPlay
//
//  Created by new on 2019/3/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRankTableViewCell.h"
#import "UIView+NTES.h"
#import "XCMacros.h"
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "TTGameRankListModel.h"
#import "TTGameRankAvatorView.h"
#import "TTGameTextScrollView.h"
#import <YYText.h>
#import "XCTheme.h" // 颜色设置的宏定义
#import "NSArray+Safe.h"

#define kScale(x) ((x) / 375.0 * KScreenWidth)
@interface TTGameRankTableViewCell ()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) TTGameRankAvatorView *avatorView;
@property (nonatomic, strong) TTGameTextScrollView *textScrollView;
@end

@implementation TTGameRankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
        
        [self.contentView addSubview:self.backImageView];
        [self.contentView addSubview:self.backButton];
    }
    return self;
}

- (void)congifModel:(TTGameRankModel *)model{
    
    NSInteger textScrollViewHeight = kScale(50);
    
    if (self.textScrollView) {
        [self.textScrollView removeFromSuperview];
    }
    self.textScrollView = [[TTGameTextScrollView alloc] initWithFrame:CGRectMake((KScreenWidth - kScale(350)) / 2 + 45, 0, kScale(350) - 45, textScrollViewHeight)];
    _textScrollView.BGColor = UIColor.clearColor;
    [self.contentView insertSubview:self.textScrollView belowSubview:self.backButton];
    
    if (model.listModelArray.count == 0) {
        self.backImageView.image = [UIImage imageNamed:@"home_rankingNoData"];
        return;
    }
    
    self.backImageView.image = [UIImage imageNamed:@"home_ranking_logo"];
    __weak typeof(self) weakSelf = self;
    NSMutableArray *gameNameArray = [NSMutableArray array];
    NSMutableArray *avatorImageArray = [NSMutableArray array];
    NSMutableArray *strArray = [NSMutableArray array];
    for (int i = 0; i < model.listModelArray.count; i++) {
        TTGameRankListModel *listModel = [model.listModelArray safeObjectAtIndex:i];
        
        [gameNameArray addObject:listModel.gameName];
        
        [avatorImageArray addObject:listModel.userList];
    }
    
    for (int i = 0; i < avatorImageArray.count; i++) {
        TTGameRankAvatorView *avatorView = [[TTGameRankAvatorView alloc] initWithFrame:CGRectMake(0, 0, kScale(350) - 45, 50)];
        avatorView.backgroundColor = UIColor.clearColor;
        
        __block NSMutableAttributedString *gameString = [[NSMutableAttributedString alloc] init];
        [avatorView configWithGameName:[gameNameArray safeObjectAtIndex:i] ImageArray:[avatorImageArray safeObjectAtIndex:i] Success:^(BOOL success) {
            
            gameString = [NSMutableAttributedString yy_attachmentStringWithContent:avatorView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(avatorView.frame.size.width, avatorView.frame.size.height) alignToFont:[UIFont systemFontOfSize:19.0] alignment:YYTextVerticalAlignmentCenter];
            
            [strArray addObject:gameString];
            
            if (strArray.count == avatorImageArray.count) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.textScrollView.titleArray = strArray;
                    if (strArray.count <= 1) {
                        weakSelf.textScrollView.timerCount = -1; // 只有一条数据时。不滚动
                    }else{
                        weakSelf.textScrollView.timerCount = [model.internal integerValue];
                    }
                });
                
            }
        }];
        
    }
}





- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"home_ranking_logo"];
        _backImageView.size = CGSizeMake(kScale(350), kScale(50));
        _backImageView.centerX = KScreenWidth / 2;
        _backImageView.top = 0;
    }
    return _backImageView;
}


- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.size = CGSizeMake(kScale(350), kScale(50));
        _backButton.centerX = KScreenWidth / 2;
        _backButton.top = 0;
        _backButton.backgroundColor = UIColor.clearColor;
        [_backButton addTarget:self action:@selector(rankJumpH5:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}



- (TTGameRankAvatorView *)avatorView{
    if (!_avatorView) {
        _avatorView = [[TTGameRankAvatorView alloc] init];
        _avatorView.size = CGSizeMake(100, 22);
        _avatorView.right = KScreenWidth - 15;
        _avatorView.centerY = _backImageView.height / 2;
    }
    return _avatorView;
}

- (void)rankJumpH5:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRankButtonJumpH5)]) {
        [self.delegate clickRankButtonJumpH5];
    }
    
}


- (UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
