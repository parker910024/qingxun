//
//  TTCPGameListView.m
//  TTPlay
//
//  Created by new on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCPGameListView.h"
#import "AuthCore.h"
#import "CPGameCore.h"
#import "TTCPGamePrivateChatClient.h"
#import "TTCPGamePrivateChatCore.h"
#import "UIView+XCToast.h"
#import "UIView+NTES.h"
#import "CPGameListModel.h"
#import "TTCPGameStaticCore.h"
#import "XCTheme.h"
#import "TTHorizontalPageControl.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UIButton+EnlargeTouchArea.h"
#import "TTGameStaticTypeCore.h"
#import "TTPopup.h"
#import "CPGameCoreClient.h"
#define kScale(x) ((x) / 375.0 * KScreenWidth)


@interface TTCPGameListView ()<UIScrollViewDelegate,CPGameCoreClient>{
    NSInteger timerNumber;
    BOOL gameClickType;
    dispatch_source_t gameTimer;
}
@property (nonatomic, strong) UIView *allBackView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray *datasourceArray;
@property (nonatomic, strong) UIScrollView *scollView;
@property (nonatomic, assign) TTGameListType listType;
@property (nonatomic, strong) TTHorizontalPageControl *horizontalPageControl;
@end


@implementation TTCPGameListView

-(instancetype)initWithFrame:(CGRect)frame WithListType:(TTGameListType )listType{
    self = [super initWithFrame:frame];
    if (self) {
        AddCoreClient(TTCPGamePrivateChatClient, self);
        AddCoreClient(CPGameCoreClient, self);
        self.listType = listType;
        
        [self addSubview:self.allBackView];
        [self addSubview:self.backView];
        [self.backView addSubview:self.scollView];
        
        if (listType == TTGameListPrivate) {
            [[GetCore(TTCPGamePrivateChatCore) requestCPGamePrivateChatList:GetCore(AuthCore).getUid.userIDValue PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
                
                [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%@",error.domain] duration:3 position:YYToastPositionCenter];
            }];
        }else if (self.listType == TTGameListNormalRoom) {
            [[GetCore(CPGameCore) requestCPGameList:GetCore(AuthCore).getUid PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
                
                [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%@",error.domain] duration:3 position:YYToastPositionCenter];
            }];
        }else{
            [[GetCore(CPGameCore) requestGameList:GetCore(AuthCore).getUid.userIDValue PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
                
                [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%@",error.domain] duration:3 position:YYToastPositionCenter];
            }];
        }
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissGameSelectPage)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}


- (void)showListViewAndRefreshData{
    if (self.listType == TTGameListPrivate) {
        [[GetCore(TTCPGamePrivateChatCore) requestCPGamePrivateChatList:GetCore(AuthCore).getUid.userIDValue PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
            
            [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%@",error.domain] duration:3 position:YYToastPositionCenter];
        }];
    }else if (self.listType == TTGameListNormalRoom) {
        [[GetCore(CPGameCore) requestCPGameList:GetCore(AuthCore).getUid PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
            
            [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%@",error.domain] duration:3 position:YYToastPositionCenter];
        }];
    } else{
        [[GetCore(TTCPGamePrivateChatCore) requestCPGamePublicChatAndNormalRoomList:GetCore(AuthCore).getUid.userIDValue PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
            
            [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%@",error.domain] duration:3 position:YYToastPositionCenter];
        }];
    }
    self.hidden = NO;
    if (self.listType != TTGameListNormalRoom) {
        
    }
}


- (void)dissGameSelectPage{
    if (self.listType != TTGameListNormalRoom) {
        self.hidden = YES;
    } else {
        [TTPopup dismiss];
    }
}

- (void)onCPRoomGetGameList:(NSArray *)listArray {
    [self.datasourceArray removeAllObjects];
    
    self.datasourceArray = [NSMutableArray arrayWithArray:listArray];

    [GetCore(TTGameStaticTypeCore).privateMessageArray removeAllObjects];
    
    NSInteger btnWidth = (KScreenWidth - kScale(74) * 4 - 14 * 2) / 3;
    
    for (int i = 0; i < self.datasourceArray.count; i++) {
        UIButton *customBtn = [self viewWithTag:100 + i];
        if (customBtn) {
            [customBtn removeFromSuperview];
            customBtn = nil;
        }
        CPGameListModel *model = self.datasourceArray[i];
        
        [GetCore(TTGameStaticTypeCore).privateMessageArray addObject:[model model2dictionary]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = CGSizeMake(kScale(74), kScale(74));
        button.left = 14 + (kScale(74) + btnWidth) * (i % 4) + (i / 8) * KScreenWidth;
        button.top = 18 + (kScale(94) + 21) * ((i - 8 * (i / 8)) / 4);
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (model.sourceType == CPGameListSourceTypeRoomGame) {
            [button sd_setImageWithURL:[NSURL URLWithString:model.gameIcon] forState:UIControlStateNormal];
        } else {
            [button sd_setImageWithURL:[NSURL URLWithString:model.gamePicture] forState:UIControlStateNormal];
        }
        
      //  [button setTitle:model.gameName forState:UIControlStateNormal];
        button.imageFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, button.width, button.width)];
        button.titleFrame = [NSValue valueWithCGRect:CGRectMake(0, button.width + 10, button.width, 15)];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scollView addSubview:button];
        
        UILabel *label = [UILabel new];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:13];
        label.text = model.gameName;
        label.size = CGSizeMake(kScale(74 + 10), 15);
        label.top = button.bottom + 10;
        label.textAlignment = NSTextAlignmentCenter;
        label.centerX = button.centerX;
        [self.scollView addSubview:label];
    }

    NSInteger viewCount = 0;
    if (self.datasourceArray.count > 8) {
        if (self.datasourceArray.count % 8 == 0){
            viewCount = self.datasourceArray.count / 8;
        }else if (self.datasourceArray.count / 8 > 0) {
            viewCount = self.datasourceArray.count / 8 + 1;
        }
    }
    
    self.scollView.contentSize = CGSizeMake(KScreenWidth * viewCount, 0);
    
    if (self.horizontalPageControl) {
        [self.horizontalPageControl removeFromSuperview];
        self.horizontalPageControl = nil;
    }
    self.horizontalPageControl = [[TTHorizontalPageControl alloc] init];
    _horizontalPageControl.size = CGSizeMake(viewCount * 5 + 7 + viewCount * 4, 6);
    _horizontalPageControl.centerX = self.width / 2;
    _horizontalPageControl.bottom = self.backView.height - 21;
    _horizontalPageControl.pages = viewCount;
    _horizontalPageControl.backgroundColor = UIColor.clearColor;
    _horizontalPageControl.currentPageColor = UIColorFromRGB(0xFFB606);
    _horizontalPageControl.normalPageColor = UIColorFromRGB(0xE2E2E2);
    _horizontalPageControl.dotBigSize = CGSizeMake(12, 5);
    _horizontalPageControl.dotNomalSize = CGSizeMake(5, 5);
    _horizontalPageControl.dotMargin = 4;
    _horizontalPageControl.startPage = 0;
    [self.backView addSubview:self.horizontalPageControl];
}

- (void)onCPGamePrivateChatList:(NSArray *)listArray{
    
    [self.datasourceArray removeAllObjects];
    
    self.datasourceArray = [NSMutableArray arrayWithArray:listArray];

    [GetCore(TTGameStaticTypeCore).privateMessageArray removeAllObjects];
    
    NSInteger btnWidth = (KScreenWidth - kScale(74) * 4 - 14 * 2) / 3;
    
    for (int i = 0; i < self.datasourceArray.count; i++) {
        UIButton *customBtn = [self viewWithTag:100 + i];
        if (customBtn) {
            [customBtn removeFromSuperview];
            customBtn = nil;
        }
        CPGameListModel *model = self.datasourceArray[i];
        
        [GetCore(TTGameStaticTypeCore).privateMessageArray addObject:[model model2dictionary]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = CGSizeMake(kScale(74), kScale(74));
        button.left = 14 + (kScale(74) + btnWidth) * (i % 4) + (i / 8) * KScreenWidth;
        button.top = 18 + (kScale(94) + 21) * ((i - 8 * (i / 8)) / 4);
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button sd_setImageWithURL:[NSURL URLWithString:model.gamePicture] forState:UIControlStateNormal];
       // [button setTitle:model.gameName forState:UIControlStateNormal];
        button.imageFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, button.width, button.width)];
        button.titleFrame = [NSValue valueWithCGRect:CGRectMake(0, button.width + 10, button.width, 15)];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scollView addSubview:button];
        
        UILabel *label = [UILabel new];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:13];
        label.text = model.gameName;
        label.size = CGSizeMake(kScale(74 + 10), 15);
        label.top = button.bottom + 10;
        label.textAlignment = NSTextAlignmentCenter;
        label.centerX = button.centerX;
        [self.scollView addSubview:label];
    }

    NSInteger viewCount = 0;
    if (self.datasourceArray.count > 8) {
        if (self.datasourceArray.count % 8 == 0){
            viewCount = self.datasourceArray.count / 8;
        }else if (self.datasourceArray.count / 8 > 0) {
            viewCount = self.datasourceArray.count / 8 + 1;
        }
    }
    
    self.scollView.contentSize = CGSizeMake(KScreenWidth * viewCount, 0);
    
    if (self.horizontalPageControl) {
        [self.horizontalPageControl removeFromSuperview];
        self.horizontalPageControl = nil;
    }
    self.horizontalPageControl = [[TTHorizontalPageControl alloc] init];
    _horizontalPageControl.size = CGSizeMake(viewCount * 5 + 7 + viewCount * 4, 6);
    _horizontalPageControl.centerX = self.width / 2;
    _horizontalPageControl.bottom = self.backView.height - 21;
    _horizontalPageControl.pages = viewCount;
    _horizontalPageControl.backgroundColor = UIColor.clearColor;
    _horizontalPageControl.currentPageColor = UIColorFromRGB(0xFFB606);
    _horizontalPageControl.normalPageColor = UIColorFromRGB(0xE2E2E2);
    _horizontalPageControl.dotBigSize = CGSizeMake(12, 5);
    _horizontalPageControl.dotNomalSize = CGSizeMake(5, 5);
    _horizontalPageControl.dotMargin = 4;
    _horizontalPageControl.startPage = 0;
    [self.backView addSubview:self.horizontalPageControl];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.size = CGSizeMake(KScreenWidth, kScale(245) + 40);
        _backView.left = 0;
        _backView.bottom = self.height;
        _backView.layer.cornerRadius = 14;
        _backView.layer.masksToBounds = YES;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIScrollView *)scollView {
    if (!_scollView) {
        _scollView = [[UIScrollView alloc] init];
        _scollView.backgroundColor = UIColor.whiteColor;
        _scollView.size = CGSizeMake(KScreenWidth, kScale(245));
        _scollView.left = 0;
        _scollView.top = 0;
        _scollView.bounces = NO;
        _scollView.pagingEnabled = YES;
        _scollView.delegate = self;
    }
    return _scollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / KScreenWidth;
    [self.horizontalPageControl setCurrentPage:index];
}

-  (void)hideView {
    self.hidden = YES;
}

- (void)itemClickAction:(UIButton *)sender {
    if (self.listType != TTGameListNormalRoom) {
        self.hidden = YES;
    } else {
        self.hidden = YES;
        [TTPopup dismiss];
    }
    CPGameListModel *model = self.datasourceArray[(sender.tag - 100)];
    if (model.sourceType == CPGameListSourceTypeRoomGame) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickRoomGameItem:)]) {
            if (model) {
                [self.delegate clickRoomGameItem:model];
            }
        }
        return;
    }
    if (self.listType == TTGameListPrivate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickItem:)]) {
            if (model) {
                [self.delegate clickItem:model];
            }
        }
        return;
    }
    
    if (gameClickType) {
        [UIView showToastInKeyWindow:[NSString stringWithFormat:@"%d秒内仅可以发起一次",GetCore(TTCPGameStaticCore).gameFrequency] duration:2 position:YYToastPositionCenter];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickItem:)]) {
            if (model) {
                [self.delegate clickItem:model];
            }
        }
    }
    
    if (!gameTimer) {
        
        timerNumber = GetCore(TTCPGameStaticCore).gameFrequency;
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        gameTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
        
        dispatch_source_set_timer(gameTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        
        dispatch_source_set_event_handler(gameTimer, ^{
            
            //1. 每调用一次 时间-1s
            timerNumber --;
            
            //2.对timeout进行判断时间是停止倒计时，
            if (timerNumber <= 0) {
                //关闭定时器
                dispatch_source_cancel(gameTimer);
                gameTimer = nil;
                gameClickType = NO;
            }else {
                gameClickType = YES;
            }
        });
        
        dispatch_resume(gameTimer);
    }
}

- (void)destructionTimer{
    if (gameTimer) {
        dispatch_source_cancel(gameTimer);
        gameTimer = nil;
    }
    gameClickType = NO;
}

- (UIView *)allBackView {
    if (!_allBackView) {
        _allBackView = [[UIView alloc] initWithFrame:self.frame];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_allBackView addGestureRecognizer:tap];
    }
    return _allBackView;
}

@end
