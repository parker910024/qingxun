//
//  TTFamilyCreateGroupTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyCreateGroupTableViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "UIImageView+QiNiu.h"
#import <YYLabel.h>
#import "TTFamilyAttributedString.h"
#import "UIView+XCToast.h"

@interface TTFamilyCreateGroupTableViewCell()<UITextFieldDelegate>


/** 分割线*/
@property (nonatomic, strong) UIView *sepView;
/** 箭头*/
@property (nonatomic, strong) UIImageView *arrowImageView;
///** 群成员*/
@property (nonatomic, strong) YYLabel * memberLabel;

@end

@implementation TTFamilyCreateGroupTableViewCell
#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - response
- (void)verswithChange:(UISwitch *)verSwitch{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchValueChange:)]) {
        [self.delegate switchValueChange:verSwitch];
    }
}

- (void)textFiledChange:(UITextField *)textFiled{
    NSString *toBeString = textFiled.text;
    NSString *lang = [textFiled.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]){// 简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [textFiled markedTextRange];
        UITextPosition *position = [textFiled positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){
            
            if (toBeString.length > 15){
                [UIView showToastInKeyWindow:@"输入字数已达上限" duration:3 position:YYToastPositionCenter];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:15];
                if (rangeIndex.length == 1){
                    textFiled.text = [toBeString substringToIndex:15];
                }else{
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 15)];
                    textFiled.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 15){
            [UIView showToastInKeyWindow:@"输入字数已达上限" duration:3 position:YYToastPositionCenter];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:15];
            if (rangeIndex.length == 1){
                textFiled.text = [toBeString substringToIndex:15];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 15)];
                textFiled.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledChangeWithString:)]) {
        [self.delegate textFiledChangeWithString:textFiled.text];
    }
}

#pragma mark - public method
- (void)configFamilyInforWith:(NSString *)familyImageUrl{
    self.iconImageView.layer.cornerRadius = 5;
    [self.iconImageView qn_setImageImageWithUrl:familyImageUrl placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
}

#pragma mark - UITextfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

#pragma mark - private method
- (void)initView{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.textFiled];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.verSwitch];
    [self.contentView addSubview:self.memberLabel];
    [self.contentView addSubview:self.numberPersonLabel];
    [self.contentView addSubview:self.sepView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
      [self.iconImageView qn_setImageImageWithUrl:@"https://img.erbanyy.com/family_group_icon.png" placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
}

- (void)initContrations{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.verSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(25);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-27);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.numberPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-25);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    
}

#pragma mark - setters and getters
- (void)setMembers:(NSMutableDictionary *)members{
    _members = members;
    if (_members) {
        _memberLabel.attributedText = [TTFamilyAttributedString createFamilyCreateGroupChooseMemberWith:_members];
    }
}

- (void)setGroupType:(FamilyCreateGroupCellType)groupType{
    _groupType = groupType;
    if (_groupType == FamilyCreateGroupCellType_GroupName) {
        self.textFiled.hidden = NO;
        self.verSwitch.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.iconImageView.hidden = YES;
        self.numberPersonLabel.hidden = YES;
        self.titleLabel.hidden = YES;
    }else{
        self.textFiled.hidden = YES;
         self.numberPersonLabel.hidden = YES;
        if (_groupType == FamilyCreateGroupCellType_GroupVer) {
            self.verSwitch.hidden = NO;
            self.arrowImageView.hidden = YES;
            self.iconImageView.hidden = YES;
            self.titleLabel.text = @"入群身份验证";
        }else{
            self.verSwitch.hidden = YES;
            self.arrowImageView.hidden = NO;
            if (_groupType == FamilyCreateGroupCellType_GroupImage) {
                self.iconImageView.hidden = NO;
                self.titleLabel.text = @"上传群头像";
            }else{
                self.numberPersonLabel.hidden = NO;
                self.iconImageView.hidden = YES;
                self.titleLabel.text = @"选择群成员";
            }
        }
        self.titleLabel.hidden = NO;
    }
    if (_groupType == FamilyCreateGroupCellType_GroupMem && self.members  && self.members.allKeys.count > 0) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.left.top.mas_equalTo(self.contentView).offset(15);
        }];
        self.numberPersonLabel.text = [NSString stringWithFormat:@"共%ld人", self.members.allKeys.count];
    }else{
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(15);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)numberPersonLabel{
    if (!_numberPersonLabel) {
        _numberPersonLabel = [[UILabel alloc] init];
        _numberPersonLabel.textColor  =  [XCTheme getTTDeepGrayTextColor];
        _numberPersonLabel.font = [UIFont systemFontOfSize:15];
        _numberPersonLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numberPersonLabel;
}


- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"discover_family_arrow"];
    }
    return _arrowImageView;
}

- (UITextField *)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.placeholder = @"请输入群昵称";
        _textFiled.font = [UIFont systemFontOfSize:14];
        _textFiled.delegate = self;
        [_textFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFiled;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 20;
    }
    return _iconImageView;
}

- (UISwitch *)verSwitch{
    if (!_verSwitch) {
        _verSwitch = [[UISwitch alloc] init];
        _verSwitch.tintColor = UIColorFromRGB(0xf5f5f5);
        _verSwitch.onTintColor = [XCTheme getTTMainColor];
        [_verSwitch addTarget:self action:@selector(verswithChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _verSwitch;
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _sepView;
}

- (YYLabel *)memberLabel{
    if (!_memberLabel) {
        _memberLabel = [[YYLabel alloc] init];
    }
    return _memberLabel;
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
