//
//  TTPrivateViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPrivateViewController.h"
#import "TTWKWebViewViewController.h"

#import <YYText/YYTextView.h>
#import "NSAttributedString+YYText.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCHtmlUrl.h"
#import "TTPopup.h"
#import "XCKeyWordTool.h"


@interface TTPrivateViewController ()
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** title */
@property (nonatomic, strong) UILabel *titleLabel;
/** contentLabel */
@property (nonatomic, strong) YYTextView *contentLabel;

/** horizontal line */
@property (nonatomic, strong) UIView *horizontalLineView;
/** vertical line */
@property (nonatomic, strong) UIView *verticalLineView;
/** disagreeButton */
@property (nonatomic, strong) UIButton *disagreeButton;
/** confirmButton */
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation TTPrivateViewController

- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
    
    self.view.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //Remove Client Here
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)onAgreementButtonClick:(UIButton *)sender {
    if (sender == self.disagreeButton) {
        
        // 呈现警告视图
        [TTPopup alertWithMessage:[NSString stringWithFormat:@"您需要同意《%@隐私政策》方可使用本软件", [XCKeyWordTool sharedInstance].myAppName] confirmHandler:^{
            
        } cancelHandler:^{
            
        }];
        
    } else if (sender == self.confirmButton) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"isShow" forKey:@"kTuTuPrivateKey"];
        //同意
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - private method

- (void)initView {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentView addSubview:self.verticalLineView];
    [self.contentView addSubview:self.horizontalLineView];
    [self.contentView addSubview:self.disagreeButton];
    [self.contentView addSubview:self.confirmButton];
}

- (void)initConstrations {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(500);
        make.left.mas_equalTo(38);
        make.right.mas_equalTo(-38);
        make.centerY.mas_equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-28);
        make.bottom.mas_equalTo(-68);
    }];
    
    [self.horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-45);
    }];
    
    [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(45);
    }];
    
    [self.disagreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(150 * KScreenWidth / 375);
        make.height.mas_equalTo(45);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(self.disagreeButton);
    }];
}

- (void)setLineSpacing:(UILabel *)label lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    label.attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:attributes];
}

#pragma mark - getters and setters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
        _titleLabel.textColor = RGBCOLOR(27, 27, 27);
        _titleLabel.text = [NSString stringWithFormat:@"“%@”隐私政策", [XCKeyWordTool sharedInstance].myAppName];
    }
    return _titleLabel;
}

- (YYTextView *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYTextView alloc]init];
        _contentLabel.editable = NO;
        _contentLabel.showsVerticalScrollIndicator = NO;
        _contentLabel.showsHorizontalScrollIndicator = NO;
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 4;
        NSString * agreement = [NSString stringWithFormat:@"欢迎您使用%@。我们将通过《隐私政策》和《用户协议》帮助您了解我们收集、使用、存储和共享个人信息的情况，特别是我们所采集的个人信息类型与用途的对应关系。\n\n为了保障产品的正常运行，我们会收集您的部分必要信息。我们可能会收集联络方式、地理位置等个人敏感信息，您有权拒绝向我们提供这些信息。我们不会向第三方共享、提供、转让或者从第三方获取您的个人信息，除非经过您的同意。\n\n", [XCKeyWordTool sharedInstance].myAppName];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
        NSAttributedString *att1 = [[NSAttributedString alloc] initWithString:agreement attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorFromRGB(0x1b1b1b), NSParagraphStyleAttributeName : paragraphStyle, NSKernAttributeName : @(1.0)}];
        
        NSMutableAttributedString *att2 = [[NSMutableAttributedString alloc] initWithString:@"您可以查看完整的《隐私政策》和《用户协议》,如果您同意,请点击下方同意按钮开始接受我们的服务。" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightMedium], NSForegroundColorAttributeName : UIColorFromRGB(0x1b1b1b), NSParagraphStyleAttributeName : paragraphStyle, NSKernAttributeName : @(1.0)}];
        @KWeakify(self);
        [att2 yy_setTextHighlightRange:NSMakeRange(8, 6) color:RGBCOLOR(52, 167, 255) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @KStrongify(self);
            TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
            web.urlString = HtmlUrlKey(kPrivacyURL);
            [self.navigationController pushViewController:web animated:YES];
        }];
        
        [att2 yy_setTextHighlightRange:NSMakeRange(15, 6) color:RGBCOLOR(52, 167, 255) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @KStrongify(self);
            TTWKWebViewViewController *web = [[TTWKWebViewViewController alloc] init];
            web.urlString = HtmlUrlKey(kUserProtocalURL);
            [self.navigationController pushViewController:web animated:YES];
        }];
        
        [attStr appendAttributedString:att1];
        [attStr appendAttributedString:att2];
        
        _contentLabel.attributedText = attStr;
    }
    return _contentLabel;
}

- (UIView *)horizontalLineView {
    if (!_horizontalLineView) {
        _horizontalLineView = [[UIView alloc] init];
        _horizontalLineView.backgroundColor = RGBCOLOR(235, 235, 235);
    }
    return _horizontalLineView;
}

- (UIView *)verticalLineView {
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = RGBCOLOR(235, 235, 235);
    }
    return _verticalLineView;
}

- (UIButton *)disagreeButton {
    if (!_disagreeButton) {
        _disagreeButton = [[UIButton alloc] init];
        [_disagreeButton setTitle:@"不同意" forState:UIControlStateNormal];
        _disagreeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_disagreeButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_disagreeButton addTarget:self action:@selector(onAgreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disagreeButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setTitle:@"同意" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onAgreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
