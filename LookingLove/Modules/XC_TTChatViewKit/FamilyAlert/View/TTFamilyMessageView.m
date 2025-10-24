//
//  TTFamilyMessageView.m
//  TuTu
//
//  Created by gzlx on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyMessageView.h"
#import "TTFamilyAlertBottomView.h"
//tool
#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface TTFamilyMessageView ()<UITextFieldDelegate>
{
    BOOL isHaveDian;
}
/** 提示*/
@property (nonatomic, strong) UILabel * tipLabel;
/** 内容*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 转让的那个人*/
@property (nonatomic, strong) UILabel * contirbuLabel;
/** 输入框*/
@property (nonatomic, strong) UITextField *textFiled;
/** 底部的View*/
@property (nonatomic, strong) TTFamilyAlertBottomView * bottomView;

@property (nonatomic, strong) TTFamilyAlertModel * config;

@end

@implementation TTFamilyMessageView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame withConfig:(TTFamilyAlertModel *)config{
    if (self = [super initWithFrame:frame]) {
        self.config = config;
        [self initView];
        [self initContrations];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)cancleButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleDismissWith:)]) {
        [self.delegate cancleDismissWith:sender];
    }
}

- (void)sureButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureButtonActionWith:)]) {
        [self.delegate sureButtonActionWith:sender];
    }
}

- (void)textFiledChange:(UITextField *)textFiled{
    if (self.config.isShowMon) {
        int maxLength = 10;
        if (textFiled.text.length > maxLength) {
            textFiled.text = [textFiled.text substringToIndex:maxLength];
        }
    }else{
        int maxLength = 15;
        if (textFiled.text.length > maxLength) {
            textFiled.text = [textFiled.text substringToIndex:maxLength];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledChangeWith:)]) {
        [self.delegate textFiledChangeWith:textFiled];
    }
}

#pragma mark - private method
- (void)configSubViewWithConfig:(TTFamilyAlertModel *)config{
    self.config = config;
    //提示的
    if (config && config.tipString.length > 0) {
        self.tipLabel.text = config.tipString;
    }
    //显示的内容
    if (config.content && config.content.length > 0) {
        NSString * title = config.content;
        //有需要改变的字体
        if (!config.contentColor) {
            config.contentColor = [XCTheme getTTMainTextColor];
        }
        NSMutableAttributedString * contetnAtt = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:config.contentColor}];
        if (config.changeColorString && config.changeColorString.length > 0) {
            NSRange range = [title rangeOfString:config.changeColorString];
            if (!config.changeColor) {
                config.changeColor = [XCTheme getTTMainColor];
            }
            if (config.changeFont) {
                [contetnAtt addAttribute:NSFontAttributeName value:config.changeFont range:range];
            }
            if (config.moreChangeColorStr) {
                NSRange moreRange = [title rangeOfString:config.moreChangeColorStr];
//                [contetnAtt addAttribute:NSFontAttributeName value:config.changeFont range:moreRange];
                if (config.moreChangeColor) {
                    [contetnAtt addAttribute:NSForegroundColorAttributeName value:config.moreChangeColor range:moreRange];
                }

            }
            if (config.changeColor) {
                [contetnAtt addAttribute:NSForegroundColorAttributeName value:config.changeColor range:range];
            }
        }
        
        if (config.contentLineSpacing > 0) {
            NSMutableParagraphStyle *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = config.contentLineSpacing;
            paragraphStyle.alignment = self.titleLabel.textAlignment;
            
            [contetnAtt addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, config.content.length)];
        }

        self.titleLabel.attributedText = contetnAtt;
    }
    //是不是显示家族b
    if (config.contribuMember && config.contribuMember.length > 0) {
        self.contirbuLabel.text = config.contribuMember;
        self.contirbuLabel.hidden = NO;
    }
    
    //输入框的配置
    if (config.textFiledHidden) {
        self.textFiled.hidden = YES;
    }else{
        self.textFiled.hidden = NO;
        if (config.keyboardType) {
            self.textFiled.keyboardType = config.keyboardType;
        }
        if (config.placeHolder && config.placeHolder.length > 0) {
            self.textFiled.placeholder = config.placeHolder;
        }
        if (config.isShowMon) {
            UILabel * rightaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 33)];
            rightaLabel.text = config.familyMon;
            rightaLabel.textColor = [XCTheme getTTMainColor];
            rightaLabel.font = [UIFont systemFontOfSize:13];
            self.textFiled.rightView = rightaLabel;
            self.textFiled.rightViewMode = UITextFieldViewModeAlways;
        }
    }
    // 底部按钮的配置
    //font:字体
    //textColor:字体颜色
    //text:显示的文字
    //backColor:背景颜色
    if (config.leftConfigDic) {
        self.bottomView.cancleButton.backgroundColor = config.leftConfigDic[@"backColor"] ? config.leftConfigDic[@"backColor"] : UIColorFromRGB(0xf0f0f0);
        self.bottomView.cancleButton.titleLabel.font = config.leftConfigDic[@"font"] ? config.leftConfigDic[@"font"] : [UIFont systemFontOfSize:15];
        [self.bottomView.cancleButton setTitle:config.leftConfigDic[@"text"]? config.leftConfigDic[@"text"]: @"取消" forState:UIControlStateNormal];
        [self.bottomView.cancleButton setTitleColor:config.leftConfigDic[@"textColor"] ? config.leftConfigDic[@"textColor"] : [XCTheme getTTMainColor] forState:UIControlStateNormal];
    }
    
    if (config.rightConfigDic) {
        self.bottomView.sureButton.backgroundColor = config.rightConfigDic[@"backColor"] ? config.rightConfigDic[@"backColor"] : [XCTheme getTTMainColor];
        self.bottomView.sureButton.titleLabel.font = config.rightConfigDic[@"font"] ? config.rightConfigDic[@"font"] : [UIFont systemFontOfSize:15];
        [self.bottomView.sureButton setTitle:config.rightConfigDic[@"text"]? config.rightConfigDic[@"text"]: @"确认" forState:UIControlStateNormal];
        [self.bottomView.sureButton setTitleColor:config.rightConfigDic[@"textColor"] ? config.rightConfigDic[@"textColor"] : [UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 14;
    [self addSubview:self.tipLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contirbuLabel];
    [self addSubview:self.textFiled];
    [self addSubview:self.bottomView];
    [self configSubViewWithConfig:self.config];
    [self addViewAction];
}

- (void)addViewAction{
    [self.textFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bottomView.sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initContrations{
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self).offset(30);
        make.right.mas_equalTo(self).offset(-30);
    }];
    
    [self.contirbuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(3);
    }];
    
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(37);
        make.right.mas_equalTo(self).offset(-37);
        make.top.mas_equalTo(self.contirbuLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(33);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(38);
        make.bottom.mas_equalTo(self).offset(-15);
    }];
}
#pragma mark -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.config.isShowMon) {
        if ([textField.text rangeOfString:@"."].location == NSNotFound){
            isHaveDian = NO;
        }
        if ([string length] > 0){
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.'){//数据格式正确
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    if (single == '0'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                //输入的字符是否是小数点
                if (single == '.'){
                    if(!isHaveDian){//text中还没有小数点
                        isHaveDian = YES;
                        return YES;
                    }else{
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHaveDian) {//存在小数点
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}



#pragma mark - setters and getters
- (TTFamilyAlertBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[TTFamilyAlertBottomView alloc] init];
    }
    return _bottomView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor  = [XCTheme getTTMainTextColor];
        _tipLabel.text = @"提示";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _tipLabel;
}

- (UILabel *)contirbuLabel{
    if (!_contirbuLabel) {
        _contirbuLabel = [[UILabel alloc] init];
        _contirbuLabel.textColor  = [XCTheme getTTMainTextColor];
        _contirbuLabel.font = [UIFont systemFontOfSize:14];
        _contirbuLabel.textAlignment = NSTextAlignmentCenter;
        _contirbuLabel.hidden = YES;
    }
    return _contirbuLabel;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITextField *)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.placeholder = @"我希望加入贵家族";
        _textFiled.font = [UIFont systemFontOfSize:15];
        _textFiled.textColor = [XCTheme getTTMainTextColor];
        _textFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 33)];
        _textFiled.leftViewMode = UITextFieldViewModeAlways;
        _textFiled.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _textFiled.layer.masksToBounds = YES;
        _textFiled.layer.cornerRadius = 5;
        _textFiled.delegate = self;
    }
    return _textFiled;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
