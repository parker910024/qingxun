//
//  KEReportController.m
//  Kelo
//
//  Created by apple on 2019/5/20.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "KEReportController.h"


//model
#import "LTReportModel.h"

//core
//#import "HttpRequestHelper+UserSetting.h"
//#import "UserSettingCoreClient.h"
//#import "UserSettingCore.h"
#import "UIView+XCToast.h"
#import "FileCore.h"
#import "FileCoreClient.h"

//tool
#import "NSBundle+Source.h"
#import "UIImage+_1x1Color.h"
#import "UIView+NTES.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"

@interface KEReportController ()
<
KEReportPictureCollectionViewDelegate,
UITextViewDelegate,
FileCoreClient
>

///图片数组
@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation KEReportController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
    [self addCore];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
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
    RemoveCoreClientAll(self);
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]
#pragma mark - [系统控件的Protocol]
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) {//删除
        return YES;
    }
    if (textView.text.length + text.length > 500) {
        [UIView showToastInKeyWindow:@"user_report_limitCotentLength" duration:1 position:YYToastPositionTop];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger textCount = 500 - self.textView.text.length;
    self.limitLab.text = [NSString stringWithFormat:@"%zd  ",textCount];
    [self.limitLab sizeToFit];
    self.limitLab.top = CGRectGetMaxY(self.textView.frame) + 5;
    self.limitLab.right = self.textView.right - 20;
}

#pragma mark - [自定义控件的Protocol]

#pragma mark - KEReportPictureCollectionViewDelegate

- (void)updatePhotoDataCallBaccWith:(NSArray *)imageArr {
    self.imageArr = imageArr;
    [self updateSubViewsFrame];
}

#pragma mark - [core相关的Protocol]

- (void)requestAddReportSuccess {
    [UIView hideToastView];
    [UIView showSuccess: @"user_report_releaseSucceedMsg"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)requestProposeSaveSuccess {
    [UIView hideToastView];
    [UIView showSuccess: @"user_advice_releaseSucceedMsg"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


#pragma mark - event response

- (void)reportAction:(UIButton *)button {
    NSString *content = @"";
    if (self.textView.text.length > 0) {
        content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (self.imageArr.count == 0 && self.type == KEReportClassTypeReport) {
        [UIView showError:@"请至少上传1张截图证明来提高举报的准确度"];
        return;
    }
    if (self.imageArr.count == 0 && content.length == 0) {
        [UIView showError: self.type == KEReportClassTypeReport ? @"user_report_checkMsg" : @"user_advice_checkMsg"];
        return;
    }
    
    if (!self.reportSelectView.reportModel && self.type == KEReportClassTypeReport) {
        [UIView showError:@"请选择举报类型"];
        return;
    }
   
    [UIView showMessage: self.type == KEReportClassTypeReport ?  @"user_report_releaseMsg": @"user_advice_releaseMsg"];
    if (self.imageArr.count) {//上传图片
//           [[LTMultiplePictureUpload shareInstance] uploadMultipleImageWithImages:self.imageArr uploadType:self.type == KEReportClassTypeAdvice ? UploadDataTypeKeloAdvice : UploadDataTypeKeloReport finish:^(NSArray * _Nonnull imgUrlArr) {
//               if (imgUrlArr.count != self.imageArr.count) {
//                   [UIView hideToastView];
//                   return ;
//               }
//               [self requesServersWithImageUrlArr:imgUrlArr];
//           }];
       }else {//没有图片
           [self requesServersWithImageUrlArr:nil];
       }
}


#pragma mark - private method

- (void)initView {
    self.navigationItem.title = self.type == KEReportClassTypeReport ? @"message_report" : @"userSetting_helpAndAdvic";
    [self.view addSubview:self.bgScrollView];
    if (self.type == KEReportClassTypeReport) {//举报
        self.textBgView.top = CGRectGetMaxY(self.reportSelectView.frame) + 15;
    }
    [self.bgScrollView addSubview:self.textBgView];
    [self.textBgView addSubview:self.textView];
    [self.textBgView addSubview:self.limitLab];
    [self.bgScrollView addSubview:self.pictureCollectionView];
    [self.bgScrollView addSubview:self.tipLabel];
    [self.bgScrollView addSubview:self.commitBtn];
    if (self.type == KEReportClassTypeReport) {//加载最后面
        [self.bgScrollView addSubview:self.reportSelectView];
    }
}

- (void)initConstrations {
    
}

- (void)addCore {
    AddCoreClient(FileCoreClient, self);
//    AddCoreClient(UserSettingCoreClient, self);
}

- (void)requesServersWithImageUrlArr:(NSArray *)urlArr {
    NSString *content = @"";
    if (self.textView.text.length > 0) {
        content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    NSString *imgUrl = urlArr.count > 0 ?  [urlArr componentsJoinedByString:@","] : nil;
    if (self.type == KEReportClassTypeReport) {//举报
        LTReportModel *model = [[LTReportModel alloc]init];
        model.toUid = self.toUid;
        model.reportContent = content;
        model.reportImage = imgUrl;
        model.reportContentType = self.reportSelectView.reportModel.value;
        model.toCommentId = self.toCommentId;
        model.dynamicId = self.dynamicId;
        model.reportType = self.reportType;
        model.barrageId = self.barrageId;
//        [GetCore(UserSettingCore) requestAddReportReportModel:model];
    }else {//帮助与建议
//        [GetCore(UserSettingCore) requestProposeSaveWithContent:content pic:imgUrl];
    }
}

- (void)updateSubViewsFrame {
    self.tipLabel.hidden = self.imageArr.count != 0;
    self.pictureCollectionView.height = self.pictureCollectionView.pictureCollectionHeight;
    self.commitBtn.top = CGRectGetMaxY(self.pictureCollectionView.frame) + 25;
    CGFloat contentSizeH = MAX(self.bgScrollView.height + 1, CGRectGetMaxY(self.commitBtn.frame) + 30);
    self.bgScrollView.contentSize = CGSizeMake(0, contentSizeH);
}

#pragma mark - getters and setters

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kNavigationHeight - kSafeAreaBottomHeight)];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.contentSize = CGSizeMake(0, _bgScrollView.height + 1);
        _bgScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _bgScrollView;
}

- (UIView *)textBgView {
    if (!_textBgView) {
        _textBgView = [[UIView alloc]initWithFrame:CGRectMake(15, 25, KScreenWidth - 30, 286)];
        _textBgView.layer.cornerRadius = 10;
        _textBgView.layer.masksToBounds = YES;
        _textBgView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    }
    return _textBgView;
}

- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 30, 250)];
        _textView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.placeholder = self.type == KEReportClassTypeReport ? @"report_placeholder" : @"advice_placeholder";
        _textView.placeholderTextColor = UIColorRGBAlpha(0xA0A0A0, 1);
        _textView.textColor = UIColorFromRGB(0x222222);
        _textView.contentInset = UIEdgeInsetsMake(10, 10, 0, 0);
        _textView.delegate = self;
    }
    return _textView;
}


- (UILabel *)limitLab {
    if (!_limitLab) {
        _limitLab = [[UILabel alloc]init];
        _limitLab.textColor = UIColorRGBAlpha(0x222222, 1);
        _limitLab.font = [UIFont systemFontOfSize:18];
        _limitLab.textAlignment = NSTextAlignmentRight;
        _limitLab.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _limitLab.text = @"500  ";
        [_limitLab sizeToFit];
        _limitLab.top = CGRectGetMaxY(self.textView.frame) + 5;
        _limitLab.right = self.textView.right - 20;
    }
    return _limitLab;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.textColor = UIColorRGBAlpha(0x999999, 1);
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.numberOfLines = 0;
        _tipLabel.text = self.type == KEReportClassTypeReport ? @"userSetting_report_tipText" :@"";
        CGFloat left = 15 + itemWH + 15;
        CGSize size = [_tipLabel sizeThatFits:CGSizeMake(KScreenWidth - left, CGFLOAT_MAX)];
        _tipLabel.size = size;
        _tipLabel.left = left;
        _tipLabel.centerY = CGRectGetMaxY(self.textBgView.frame) + 16 + itemWH/2.f;
        _tipLabel.width = KScreenWidth - _tipLabel.left;
    }
    return _tipLabel;
}

- (KEReportPictureCollectionView *)pictureCollectionView {
    if (!_pictureCollectionView) {
        _pictureCollectionView = [[KEReportPictureCollectionView alloc]init];
        _pictureCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.textBgView.frame) + 16, KScreenWidth, self.pictureCollectionView.pictureCollectionHeight);
        _pictureCollectionView.delegate = self;
    }
    return _pictureCollectionView;
}


- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.frame = CGRectMake(48, CGRectGetMaxY(self.pictureCollectionView.frame) + 25, KScreenWidth - 48*2, 60);
        _commitBtn.layer.cornerRadius = 30;
        _commitBtn.layer.masksToBounds = YES;
        _commitBtn.backgroundColor = UIColorFromRGB(0xffffff);
        [_commitBtn setTitle:@"userSetting_report_submit" forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_commitBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:[UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0x39E2C6)] forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:[UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0x1CCDB0)] forState:UIControlStateHighlighted];
        [_commitBtn setBackgroundImage:[UIImage instantiate1x1ImageWithColor:UIColorRGBAlpha(0x39E2C6, 0.3)] forState:UIControlStateDisabled];
        [_commitBtn addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (LTReportTypeSelectView *)reportSelectView {
    if (!_reportSelectView) {
        _reportSelectView = [[LTReportTypeSelectView alloc] initWithFrame:CGRectMake(15, 16, KScreenWidth - 15*2, 70)];
    }
    return _reportSelectView;
}

//- (NSMutableArray *)imgUrlArr {
//    if (!_imgUrlArr) {
//        _imgUrlArr = [NSMutableArray array];
//    }
//    return _imgUrlArr;
//}



@end
