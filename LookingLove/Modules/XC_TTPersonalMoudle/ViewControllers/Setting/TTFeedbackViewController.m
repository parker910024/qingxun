//
//  TTFeedbackViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFeedbackViewController.h"
//view
#import <SZTextView/SZTextView.h>
#import "TTFeedbackAlbumView.h"

//core
#import "FeedbackCoreClient.h"
#import "FeedbackCore.h"
#import "FileCore.h"

//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCKeyWordTool.h"
#import "BaseAttrbutedStringHandler.h"

//cate
#import "XCHUDTool.h"

#import <YYText/YYText.h>
#import "ClientCore.h"
#import "TTWKWebViewViewController.h"
#import "XCHtmlUrl.h"

@interface TTFeedbackViewController ()<FeedbackCoreClient, TTFeedbackAlbumViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) SZTextView *contentTextView;
@property (nonatomic, strong) UITextField *contactField;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) YYLabel *albumLabel;//图片说明(单张图片不超过1M)
@property (nonatomic, strong) TTFeedbackAlbumView *albumView;

@property (nonatomic, strong) UILabel *kfLabel1;
@property (nonatomic, strong) UILabel *kfLabel2;

@end

@implementation TTFeedbackViewController
- (void)dealloc
{
    RemoveCoreClient(FeedbackCoreClient, self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self addClient];
    [self initSubviews];
}

- (void)addClient {
    AddCoreClient(FeedbackCoreClient, self);
}

- (void)initSubviews {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.contactField];
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.kfLabel1];
    [self.view addSubview:self.kfLabel2];
    [self.view addSubview:self.albumLabel];
    [self.view addSubview:self.albumView];
    [self makeConstriants];
    
    if(GetCore(ClientCore).customerType == 2){
        self.kfLabel1.hidden = NO;
        self.kfLabel2.hidden = NO;
    }
}

- (void)makeConstriants {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_topLayoutGuide).offset(20);
    }];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(174);
    }];
    [self.contactField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentTextView.mas_bottom).offset(12);
        make.left.right.mas_equalTo(self.contentTextView);
        make.height.mas_equalTo(44);
    }];
    [self.albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contactField.mas_bottom).offset(30);
        make.left.mas_equalTo(self.titleLabel);
    }];
    [self.albumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.albumLabel.mas_bottom).offset(16);
        make.left.right.mas_equalTo(self.contentTextView);
        make.height.mas_equalTo([self.albumView height]);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.albumView.mas_bottom).offset(80);
        make.left.right.mas_equalTo(self.view).inset(48);
        make.height.mas_equalTo(48);
    }];
    
    [self.kfLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.submitBtn.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-30);
    }];
    
    [self.kfLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kfLabel1.mas_top);
        make.left.mas_equalTo(self.kfLabel1.mas_right);
    }];
}

//反馈来源(SET_UP_PAGE -- 设置页, DRAW -- 转盘活动, ROOM_RED -- 房间红包)
- (NSString *)sourceValue:(TTFeedbackSouce)source {
    switch (source) {
        case TTFeedbackSouceSetting:
            return @"SET_UP_PAGE";
        case TTFeedbackSouceDraw:
            return @"DRAW";
        case TTFeedbackSouceRoomRed:
            return @"ROOM_RED";
        default:
            return nil;
    }
}

#pragma mark - FeedbackCoreClient
- (void)onRequestFeedbackSuccess {
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showSuccessWithMessage:[NSString stringWithFormat:@"感谢您的宝贵意见，让我们共同营造更好的%@", [XCKeyWordTool sharedInstance].myAppName]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)onRequestFeedbackFailth {
    [XCHUDTool hideHUDInView:self.view];
}

#pragma mark - Event
- (void)onClickSubmitBtnAction {
    
    if (self.contentTextView.text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"内容不能为空" inView:self.view];
        return;
    }
    
    [self.contentTextView resignFirstResponder];
    [self.contactField resignFirstResponder];
    
    [XCHUDTool showGIFLoading];
    
    NSString *source = [self sourceValue:self.souce];
    //无图片
    if (self.albumView.dataArray.count == 0) {
        [GetCore(FeedbackCore) requestFeedback:self.contentTextView.text
                                       contact:self.contactField.text
                                        source:source
                                     imageURLs:nil];
        return;
    }
    
    //带图片
    @weakify(self);
    [GetCore(FileCore) uploadImages:self.albumView.dataArray bizType:HttpRequestHelperUploadBizTypeFeedback success:^(NSArray<UploadImage *> *data) {
        
        @strongify(self);
        if (data.count != self.albumView.dataArray.count) {
             [XCHUDTool hideHUD];
             [XCHUDTool showErrorWithMessage:@"选择的图片和上传成功图片数量不一致（开发测试使用）"];
             return;
        }

        NSMutableString *urls = [NSMutableString string];
        for (UploadImage *img in data) {
            if (urls.length > 0) {
                [urls appendString:@","];
            }
            [urls appendString:img.url];
        }
        
        [GetCore(FeedbackCore) requestFeedback:self.contentTextView.text
                                       contact:self.contactField.text
                                        source:source
                                     imageURLs:urls];
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

#pragma mark - LLPostDynamicAlbumViewDelegate
/// 将要新增照片
- (void)albumViewWillAppendPhoto:(TTFeedbackAlbumView *)view {
    [self.contentTextView resignFirstResponder];
    [self.contactField resignFirstResponder];
}

/// 将要浏览照片
- (void)albumViewWillBrowserPhoto:(TTFeedbackAlbumView *)view {
    [self.contentTextView resignFirstResponder];
    [self.contactField resignFirstResponder];
}

/// 已经新增照片
- (void)albumViewHadAppendPhoto:(TTFeedbackAlbumView *)view {
}

/// 已经删除照片
- (void)albumViewHadDeletePhoto:(TTFeedbackAlbumView *)view {
}

- (void)toKfAction{
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    webView.urlString = HtmlUrlKey(kLive800);
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - Getter && Setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"问题描述";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = XCThemeMainTextColor;
    }
    return _titleLabel;
}

- (SZTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[SZTextView alloc] init];
        _contentTextView.placeholder = @"请详细描述您所遇到的问题，感谢你提出宝贵意见";
        _contentTextView.textColor = [XCTheme getTTDeepGrayTextColor];
        _contentTextView.backgroundColor = [XCTheme getTTSimpleGrayColor];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        _contentTextView.layer.cornerRadius = 8;
    }
    return _contentTextView;
}

- (UITextField *)contactField {
    if (!_contactField) {
        _contactField = [[UITextField alloc] init];
        _contactField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的QQ或微信号" attributes:@{NSForegroundColorAttributeName : [XCTheme getTTDeepGrayTextColor]}];
        _contactField.font = [UIFont systemFontOfSize:14];
        _contactField.textColor = [XCTheme getTTDeepGrayTextColor];
        _contactField.backgroundColor = [XCTheme getTTSimpleGrayColor];
        _contactField.layer.cornerRadius = 8;
    }
    return _contactField;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.backgroundColor = [XCTheme getTTMainColor];
        _submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(onClickSubmitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 24;
    }
    return _submitBtn;
}

- (UILabel *)kfLabel1 {
    if (!_kfLabel1) {
        _kfLabel1 = [[UILabel alloc] init];
        _kfLabel1.text = @"遇到的情况比较紧急，可快速进入";
        _kfLabel1.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _kfLabel1.textColor = UIColorFromRGB(0x333333);
        _kfLabel1.hidden = YES;
    }
    return _kfLabel1;
}

- (UILabel *)kfLabel2 {
    if (!_kfLabel2) {
        _kfLabel2 = [[UILabel alloc] init];
        _kfLabel2.text = @"人工客服";
        _kfLabel2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _kfLabel2.textColor = XCThemeMainColor;
        _kfLabel2.hidden = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toKfAction)];
        [_kfLabel2 addGestureRecognizer:gesture];
        _kfLabel2.userInteractionEnabled = YES;
    }
    return _kfLabel2;
}

- (YYLabel *)albumLabel {
    if (_albumLabel == nil) {
        _albumLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        [str appendAttributedString:[BaseAttrbutedStringHandler textAttributedString:@"图片说明" textColor:XCThemeMainTextColor textFont:[UIFont systemFontOfSize:14] alignmentFont:[UIFont systemFontOfSize:15]]];
        [str appendAttributedString:[BaseAttrbutedStringHandler textAttributedString:@"(单张图片不超过1M)" textColor:[XCTheme getTTDeepGrayTextColor] textFont:[UIFont systemFontOfSize:13] alignmentFont:[UIFont systemFontOfSize:15]]];
        
        _albumLabel.attributedText = str;
    }
    return _albumLabel;
}

- (TTFeedbackAlbumView *)albumView {
    if (!_albumView) {
        _albumView = [[TTFeedbackAlbumView alloc] init];
        _albumView.delegate = self;
    }
    return _albumView;
}

@end
