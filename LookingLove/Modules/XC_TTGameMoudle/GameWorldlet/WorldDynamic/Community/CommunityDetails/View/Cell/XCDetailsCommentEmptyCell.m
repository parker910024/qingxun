//
//  XCDetailsCommentEmptyCell.m
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "XCDetailsCommentEmptyCell.h"
#import "UIView+NTES.h"
#import "XCTheme.h"

@interface XCDetailsCommentEmptyCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@end
@implementation XCDetailsCommentEmptyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView sizeToFit];
    self.imgView.center = self.contentView.center;
    self.imgView.centerY = self.contentView.center.y-30;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.center = self.contentView.center;
    self.titleLabel.top = self.imgView.bottom+10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0xB3B3B3);
        _titleLabel.text = @"快来抢占沙发吧~" ;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLabel;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamic_comment_empty_icon"]];
    }
    return _imgView;
}
@end
