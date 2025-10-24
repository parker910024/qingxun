//
//  LTCommentFooterView.m
//  UKiss
//
//  Created by apple on 2018/12/10.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "LTCommentFooterView.h"
#import "UIView+NTES.h"
#import "XCMacros.h"
#import "XCTheme.h"

@implementation LTCommentFooterView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]

#pragma mark - [自定义控件的Protocol]

#pragma mark - [core相关的Protocol] 

#pragma mark - event response

- (void)historyButtonClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyButtonClick)]) {
        [self.delegate historyButtonClick];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.historyButton];
    [self addSubview:self.lineView];
}

- (void)initConstrations {
    [self.historyButton sizeToFit];
    self.historyButton.center = self.center;
    

    self.lineView.top = self.historyButton.bottom - 6;
    self.lineView.height = 0.5;
    self.lineView.width = self.historyButton.width;
    self.lineView.left = self.historyButton.left;
}

#pragma mark - getters and setters
- (UIButton *)historyButton{
    if (!_historyButton) {
        _historyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        NSString * str = @"查看历史消息";
        
        //建立行间距模型
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        
        //设置行间距
        [paragraphStyle1 setLineSpacing:5.f];
        
        NSAttributedString * att = [[NSAttributedString alloc] initWithString:str attributes:
                                    @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                      NSForegroundColorAttributeName : UIColorFromRGB(0x222222),
//                                      NSUnderlineStyleAttributeName : @(1),
//                                      NSParagraphStyleAttributeName :paragraphStyle1
                                      }];
        _historyButton.frame = CGRectMake(0, 30, KScreenWidth, 20);
        [_historyButton setAttributedTitle:att forState:UIControlStateNormal];
        [_historyButton addTarget:self action:@selector(historyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyButton;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0x222222);
    }
    return _lineView;
}
@end
