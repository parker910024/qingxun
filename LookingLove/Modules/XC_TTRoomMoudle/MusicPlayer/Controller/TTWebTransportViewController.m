//
//  XCWebTransportViewController.m
//  TuTu
//
//  Created by 卫明 on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTWebTransportViewController.h"

//core
#import "FileCore.h"
#import "MusicCache.h"

//client
#import "FileCoreClient.h"

//tool
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "SJXCSMIPHelper.h"
#import "UIImage+Utils.h"
#import <AFNetworkReachabilityManager.h>
#import <Masonry/Masonry.h>
#import "XCMacros.h"

//theme
#import "XCTheme.h"

//const
#import "XCConst.h"


@interface TTWebTransportViewController ()
<
    UINavigationBarDelegate,
    UINavigationControllerDelegate,
    FileCoreClient
>

@property (strong, nonatomic) HTTPServer *server;

@property (strong, nonatomic) NSString *ip;

@property (nonatomic,assign) NSInteger countOfSong;

@property (strong, nonatomic) UIView *wifiContainer;

@property (strong, nonatomic) UIImageView *wifiIcon;

@property (strong, nonatomic) UILabel *wifiTipsLabel;

@property (strong, nonatomic) UILabel *tipsLabel;

@property (strong, nonatomic) UILabel *ipLabel;

@property (strong, nonatomic) UIImageView *guideImageView;

@property (strong, nonatomic) UILabel *progressLabel;

@property (strong, nonatomic) UIView *songCountContainer;

@property (strong, nonatomic) UILabel *songNumber;

@property (strong, nonatomic) UIButton *finishButton;

@end

@implementation TTWebTransportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initConstrations];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFile) name:@"processEpilogueData" object:nil];
    
    [self configServer];
    [self addDelegate];
    [self addNetworkObvser];
}

- (void)configServer {
    // 获取文件存储位置
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"filePath : %@", filePath);
    
    self.server = [[HTTPServer alloc] init];
    [self.server setType:@"_http._tcp."];
    
    // webPath是server搜寻HTML等文件的路径
    NSString *webPagePath = [[NSBundle mainBundle] resourcePath];
    [self.server setDocumentRoot:webPagePath];
    [self.server setConnectionClass:[MyHTTPConnection class]];
}

- (void)addDelegate {
    for (MyHTTPConnection *item in [self.server getConnectionsInServer]) {
        [GetCore(FileCore)setDelegate:item]; //把filecore设置为connection的delegate
    }

}

- (void)addNetworkObvser {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    NSError * err;
    if ([self.server start:&err]) {
        self.ip = [NSString string];
        //[[SJXCSMIPHelper deviceIPAdress] isEqualToString:@"an error occurred when obtaining ip address"]
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            self.ip = @"（您正在4G/3G/2G网络下，暂无法使用）";
            self.wifiTipsLabel.text = @"请连接WIFI";
        } else if (status == AFNetworkReachabilityStatusNotReachable) {
            self.ip = @"您当前无网络";
            self.wifiTipsLabel.text = @"请连接WIFI";
        } else {
            self.ip = [NSString stringWithFormat:@"http://%@:%d/",[SJXCSMIPHelper deviceIPAdress],[self.server listeningPort]];
            self.wifiTipsLabel.text = @"已连接WIFI";
        }
        self.ipLabel.text = self.ip;
    } else {
    }
    
    @weakify(self);
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                self.ipLabel.text = @"您当前无网络";
                self.wifiTipsLabel.text = @"请连接WIFI";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.ipLabel.text = @"您正在4G/3G/2G网络下，暂无法使用";
                self.wifiTipsLabel.text = @"请连接WIFI";
            default:
                self.tipsLabel.text = self.ip;
                self.wifiTipsLabel.text = @"已连接WIFI";
                break;
        }
    }];

}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)updateFile {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"连通啦");
        GetCore(FileCore).uploadMusicList;
        self.countOfSong++;
        [self updateSongCount:self.countOfSong];
    });
}

- (void)updateSongCount:(NSInteger)count {
    NSString *countStr = [NSString stringWithFormat:@"%ld",count];
    
    UIColor *blackColor = UIColorFromRGB(0x333333);
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] init];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:blackColor};
    [attriStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"已导入" attributes:dic]];
    [attriStr appendAttributedString:[[NSAttributedString alloc] initWithString:countStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:blackColor}]];
    [attriStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"首歌" attributes:dic]];
    self.songNumber.attributedText = attriStr;
}

#pragma mark - Event
- (void)onFinishButtonClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initView {
    self.title = @"传输歌曲";
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.wifiContainer];
    [self.wifiContainer addSubview:self.wifiIcon];
    [self.wifiContainer addSubview:self.wifiTipsLabel];
    
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.ipLabel];
    
    [self.view addSubview:self.guideImageView];
    
    [self.view addSubview:self.progressLabel];
    
    [self.view addSubview:self.songCountContainer];
    [self.songCountContainer addSubview:self.songNumber];
    [self.view addSubview:self.finishButton];
}

- (void)initConstrations {
    [self.wifiContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(20);
        make.width.mas_equalTo(132);
        make.height.mas_equalTo(30);
    }];
    
    [self.wifiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(self.wifiContainer.mas_centerY);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    
    [self.wifiTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.wifiIcon.mas_trailing).offset(7);
        make.centerY.mas_equalTo(self.wifiContainer.mas_centerY);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.wifiContainer.mas_bottom).offset(17);
    }];
    
    [self.ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(15);
    }];
    
    [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.ipLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(229);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(230); make.top.mas_equalTo(self.guideImageView.mas_bottom).offset(15);
    }];
    
    [self.songCountContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.progressLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(178);
        make.height.mas_equalTo(35);
    }];
    
    [self.songNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.songCountContainer);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(16);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-16);
        make.top.mas_equalTo(self.songCountContainer.mas_bottom).offset(16);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - getters and setters
- (UIView *)wifiContainer {
    if (!_wifiContainer) {
        _wifiContainer = [[UIView alloc] init];
        _wifiContainer.layer.cornerRadius = 15;
        _wifiContainer.layer.masksToBounds = YES;
        _wifiContainer.backgroundColor = UIColorFromRGB(0xe4e1e1);
    }
    return _wifiContainer;
}

- (UIImageView *)wifiIcon {
    if (!_wifiIcon) {
        _wifiIcon = [[UIImageView alloc] init];
        _wifiIcon.image = [UIImage imageNamed:@"room_music_player_trans_wifi"];
    }
    return _wifiIcon;
}

- (UILabel *)wifiTipsLabel {
    if (!_wifiTipsLabel) {
        _wifiTipsLabel = [[UILabel alloc] init];
        _wifiTipsLabel.textColor = UIColorFromRGB(0x1a1a1a);
        _wifiTipsLabel.text = @"请连接WIFI";
        _wifiTipsLabel.font = [UIFont systemFontOfSize:15];
    }
    return _wifiTipsLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = RGBCOLOR(51, 51, 51);
        _tipsLabel.text = @"如图:请在同一WiFi下电脑浏览器上输入";
        _tipsLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tipsLabel;
}

- (UILabel *)ipLabel {
    if (!_ipLabel) {
        _ipLabel = [[UILabel alloc] init];
        _ipLabel.textColor = UIColorFromRGB(0xF23333);
        _ipLabel.font = [UIFont systemFontOfSize:14];
    }
    return _ipLabel;
}

- (UIImageView *)guideImageView {
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] init];
        _guideImageView.image = [UIImage imageNamed:@"room_music_player_trans_computer"];
    }
    return _guideImageView;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = UIColorFromRGB(0x333333);
        _progressLabel.text = @"可在打开的网页上导入和删除歌曲\n歌曲导入完成前，请不要退出当前页面";
        _progressLabel.font = [UIFont systemFontOfSize:13];
        _progressLabel.numberOfLines = 0;
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}

- (UIView *)songCountContainer {
    if (!_songCountContainer) {
        _songCountContainer = [[UIView alloc] init];
        _songCountContainer.layer.cornerRadius = 17.5;
        _songCountContainer.layer.masksToBounds = YES;
        _songCountContainer.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _songCountContainer;
}

- (UILabel *)songNumber {
    if (!_songNumber) {
        _songNumber = [[UILabel alloc] init];
        _songNumber.textColor = UIColorFromRGB(0x333333);
        _songNumber.font = [UIFont systemFontOfSize:14]; // 14 18
        _songNumber.textAlignment = NSTextAlignmentCenter;
        _songNumber.text = @"已导入0首歌";
    }
    return _songNumber;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] init];
        [_finishButton setTitle:@"保存" forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_finishButton addTarget:self action:@selector(onFinishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _finishButton.layer.cornerRadius = 20;
        _finishButton.layer.masksToBounds = YES;
        _finishButton.backgroundColor = [XCTheme getTTMainColor];
    }
    return _finishButton;
}



@end
