//
//  TTFamilyMonTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyMonTableViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "FamilyCore.h"
#import "UIImageView+QiNiu.h"
#import "NSString+Utils.h"
#import "PLTimeUtil.h"
#import "TTUserCardContainerView.h"
#import "XCMacros.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTPopup.h"

@interface TTFamilyMonTableViewCell()
/** 头像*/
@property (nonatomic, strong) UIImageView * iconImageView;
/** 名字i*/
@property (nonatomic, strong) UILabel * nameLabel;
/** 类型*/
@property (nonatomic, strong) UILabel * typeLabel;
/** 金币*/
@property (nonatomic, strong) UILabel * monLable;
/** 日期*/
@property (nonatomic, strong) UILabel * dateLabel;
/** 分割线*/
@property (nonatomic, strong) UIView * sepView;
@property (nonatomic, strong) XCFamilyModel * modelInfor;
@end

@implementation TTFamilyMonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - response
- (void)logoTapActionRecognize:(UITapGestureRecognizer *)tap{
    if (self.modelInfor && self.modelInfor.uid.userIDValue > 0) {
        TTUserCardFunctionItem * item = [[TTUserCardFunctionItem alloc] init];
        item.type = TTUserCardFunctionItemType_PersonPage;
        item.normalTitle = @"个人主页";
        item.actionId = self.modelInfor.uid.userIDValue;
        item.actionBolock = ^(UserID uid, NSIndexPath * _Nonnull indexPath, TTUserCardFunctionItem * _Nonnull item) {
            
            [TTPopup dismiss];
            
            UIViewController * person = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:uid];
            [self.currentController.navigationController pushViewController:person animated:YES];
        };
        NSArray * bottomArray = @[item];
        CGFloat height = [TTUserCardContainerView getTTUserCardContainerViewHeightWithFunctionArray:[@[] mutableCopy] bottomOpeArray:[bottomArray mutableCopy]];
        TTUserCardContainerView * cardView = [[TTUserCardContainerView alloc] initWithFrame:CGRectMake(0, 0, 314, height) uid:self.modelInfor.uid.userIDValue];
      
        [cardView setTTUserCardContainerViewHeightWithFunctionArray:nil bottomOpeArray:[@[item] mutableCopy]];
        
        [TTPopup popupView:cardView style:TTPopupStyleAlert];
    }
}

- (void)configTTMonCellWithMonInfor:(XCFamilyModel *)family{
    if (family) {
        self.modelInfor = family;
        NSString * moneyName = [GetCore(FamilyCore) getFamilyModel].moneyName;
        NSMutableString *  name = [[NSString stringWithFormat:@"%@", family.nick] mutableCopy];
        if (self.type == FamilyMoneyOwnerGroup) {
            name = [[NSString stringWithFormat:@"%@", family.nick] mutableCopy];
        }else{
            name = [[NSString stringWithFormat:@"%@", family.title] mutableCopy];
        }
        if (name.length > 8) {
            name = [[[name substringToIndex:8] stringByAppendingString:@"..."] mutableCopy];
        }
    
        [self.iconImageView qn_setImageImageWithUrl:family.avatar placeholderImage:[[XCTheme defaultTheme] default_empty] type:ImageTypeHomePageItem];
        self.nameLabel.text = name;
        NSString * dataTime =  [PLTimeUtil getDateWithTotalTimeWith:family.time];
        self.dateLabel.text = dataTime;
        if (family.amount > 0) {
            self.monLable.textColor = [XCTheme getTTMainColor];
              self.monLable.text =[NSString stringWithFormat:@"+%@%@",[NSString changeAsset:[NSString stringWithFormat:@"%.2f", family.amount]], moneyName];
        }else{
            self.monLable.textColor = [XCTheme getTTMainTextColor] ;
              self.monLable.text =[NSString stringWithFormat:@"%@%@",[NSString changeAsset:[NSString stringWithFormat:@"%.2f", family.amount]], moneyName];
        }
      
        self.typeLabel.text =[NSString stringWithFormat:@"[%@]",  family.source];
    }
}

#pragma makr - private method
- (void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.monLable];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.sepView];
}

- (void)initContrations{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70);
        make.top.mas_equalTo(self.contentView).offset(17);
        make.right.mas_equalTo(self.contentView).offset(-50);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
    }];
    
    [self.monLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.contentView).offset(100);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.monLable.mas_bottom).offset(10);
        make.left.mas_equalTo(self.typeLabel.mas_right).offset(15);
    }];
}
#pragma mark - setters and getters
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.contentMode = UIViewContentModeScaleToFill;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 20;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoTapActionRecognize:)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor  = [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor  = [XCTheme getTTDeepGrayTextColor];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}

- (UILabel *)monLable{
    if (!_monLable) {
        _monLable = [[UILabel alloc] init];
        _monLable.textColor  = [XCTheme getTTMainColor];
        _monLable.font = [UIFont systemFontOfSize:16];
        _monLable.textAlignment = NSTextAlignmentRight;
    }
    return _monLable;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor  = [XCTheme getTTDeepGrayTextColor];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
