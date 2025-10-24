//
//  TTOppositeSexMatchViewController.m
//  AFNetworking
//
//  Created by new on 2019/4/18.
//

#import "TTOppositeSexMatchViewController.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "TTPopup.h"

#import "CPGameCore.h"
#import "AuthCore.h"
#import "APNSCoreClient.h"

#import "XCMediator+TTRoomMoudleBridge.h" // 匹配到跳转房间

// SVG动画
#import "SVGA.h"
#import "SVGAParserManager.h"

@interface TTOppositeSexMatchViewController ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) SVGAImageView *telepathyImageView;
@property (nonatomic, strong) SVGAParserManager *parserManager;
@property (nonatomic, strong) UIView *heartView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger countNumber;
@property (nonatomic, strong) UILabel *matchSuccessLabel;
@property (nonatomic, strong) UILabel *enterRoomLabel;

@end

@implementation TTOppositeSexMatchViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    RemoveCoreClientAll(self);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AddCoreClient(APNSCoreClient, self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorRGBAlpha(0x000000, 0.3);
    
    [self initView];
    
    [self initConstraint];

    self.countNumber = 0;
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(matchNumberAction:) userInfo:nil repeats:YES];
    
    [self loadSvgaAnimation:@"oppositeSex_ing"];
}

#pragma mark --- APNSCoreClient 异性匹配到人 ---
- (void)onOppositeSexMatchingWithData:(NSDictionary *)dict {
    RemoveCoreClientAll(self);
    [self matchSuccess];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
        
        [TTPopup dismiss];
        
        if ([dict[@"second"] intValue] == 361) { // 异性匹配推送:  都是外部匹配
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[dict[@"data"][@"roomUid"] userIDValue]];
        } else if ([dict[@"second"] intValue] == 362) { // 异性匹配推送:  其中一个是房间内的匹配
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[dict[@"data"][@"roomUid"] userIDValue]];
        }
    });
}

- (void)matchSuccess {
    self.heartView.hidden = YES;
    self.cancelButton.hidden = YES;
    self.matchSuccessLabel.hidden = NO;
    self.enterRoomLabel.hidden = NO;
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

- (void)initView {
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.telepathyImageView];
    [self.backView addSubview:self.heartView];
    [self.heartView addSubview:self.titleLabel];
    [self.heartView addSubview:self.countDownLabel];
    [self.backView addSubview:self.cancelButton];
    [self.backView addSubview:self.matchSuccessLabel];
    [self.backView addSubview:self.enterRoomLabel];
}

- (void)initConstraint {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(230, 180));
        make.center.mas_equalTo(self.view);
    }];
    
    [self.telepathyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(76, 76));
        make.centerX.mas_equalTo(self.backView);
        make.top.mas_equalTo(14);
    }];
    
    [self.heartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).offset(104);
        make.size.mas_equalTo(CGSizeMake(100, 16));
        make.centerX.mas_equalTo(self.backView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
    }];
    
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(7);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.heartView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 29));
        make.centerX.mas_equalTo(self.backView);
    }];
    
    [self.matchSuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).offset(104);
        make.centerX.mas_equalTo(self.backView);
    }];
    
    [self.enterRoomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.matchSuccessLabel.mas_bottom).offset(13);
        make.centerX.mas_equalTo(self.backView);
    }];
    
}

- (void)cancelButtonAction:(UIButton *)sender {
    [self cancelOppositeSexMatch];
}

- (void)matchNumberAction:(NSTimer *)timer {
    self.countNumber++;
    if (self.countNumber > 12) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        [self.telepathyImageView stopAnimation];
        [GetCore(CPGameCore) userRemoveOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(oppositeSexMatchTimeoutWith:)]) {
            [self.delegate oppositeSexMatchTimeoutWith:self];
        }
    }
    self.countDownLabel.text = [NSString stringWithFormat:@"%lds",self.countNumber];
}

- (void)cancelOppositeSexMatch {
    [self.telepathyImageView stopAnimation];
    [GetCore(CPGameCore) userRemoveOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)loadSvgaAnimation:(NSString *)matchStr{
    
    NSString *matchString = [[NSBundle mainBundle] pathForResource:matchStr ofType:@"svga"];
    if (!matchString) {
        return;
    }
    NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
    
    @KWeakify(self);
    [self.parserManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.telepathyImageView.loops = INT_MAX;
        self.telepathyImageView.clearsAfterStop = NO;
        self.telepathyImageView.videoItem = videoItem;
        [self.telepathyImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0xffffff);
        _backView.layer.cornerRadius = 14;
    }
    return _backView;
}

- (SVGAImageView *)telepathyImageView {
    if (!_telepathyImageView) {
        _telepathyImageView = [[SVGAImageView alloc]init];
        _telepathyImageView.contentMode = UIViewContentModeScaleAspectFill;
        _telepathyImageView.backgroundColor = [UIColor clearColor];
    }
    return _telepathyImageView;
}

- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc]init];
    }
    return _parserManager;
}


- (UIView *)heartView {
    if (!_heartView) {
        _heartView = [[UIView alloc] init];
    }
    return _heartView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"心灵感应中";
    }
    return _titleLabel;
}

- (UILabel *)countDownLabel {
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] init];
        _countDownLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _countDownLabel.font = [UIFont systemFontOfSize:14];
        _countDownLabel.text = @"0s";
    }
    return _countDownLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB(0xB4B4B4) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.layer.cornerRadius = 14;
        _cancelButton.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)matchSuccessLabel {
    if (!_matchSuccessLabel) {
        _matchSuccessLabel = [[UILabel alloc] init];
        _matchSuccessLabel.textColor = [XCTheme getTTMainTextColor];
        _matchSuccessLabel.font = [UIFont systemFontOfSize:16];
        _matchSuccessLabel.text = @"匹配成功";
        _matchSuccessLabel.hidden = YES;
    }
    return _matchSuccessLabel;
}

- (UILabel *)enterRoomLabel {
    if (!_enterRoomLabel) {
        _enterRoomLabel = [[UILabel alloc] init];
        _enterRoomLabel.textColor = UIColorFromRGB(0xB4B4B4);
        _enterRoomLabel.font = [UIFont systemFontOfSize:13];
        _enterRoomLabel.text = @"正在进入房间";
        _enterRoomLabel.hidden = YES;
    }
    return _enterRoomLabel;
}

@end
