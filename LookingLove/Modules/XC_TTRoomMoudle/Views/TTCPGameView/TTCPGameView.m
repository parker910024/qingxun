//
//  TTCPGameView.m
//  TuTu
//
//  Created by new on 2019/1/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCPGameView.h"
#import "TTGameRoomViewController+CPGameView.h"

#import "XCMacros.h"
#import "ImMessageCore.h"
#import "ImRoomCoreV2.h"
#import <Masonry/Masonry.h>
#import "UserCore.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "PraiseCore.h"
#import "PraiseCoreClient.h"
#import "TTCPGameCustomModel.h"

#import "NSArray+Safe.h"
#import "UIView+NTES.h"

#import "TTCPGameCustomView.h"
#import "TTCPGameCustomScollView.h"
#import "TTCustomAvatorImageView.h"

#import "TTCPGameListItemView.h"

#import "TTRibbonsAnimation.h" // 彩带动画

#import "TTGameSelectView.h" // 游戏选择的View

#define kScale(x) ((x) / 375.0 * KScreenWidth)

@interface TTCPGameView ()<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger selectIndex; // 当前选择的游戏下标;
@property (nonatomic, assign) BOOL attention;
@property (nonatomic, assign) UserID attenId;
@property (nonatomic, assign) BOOL leftAttention;
@property (nonatomic, assign) BOOL rightAttention;
@property (nonatomic, assign) UserID leftAttenID;
@property (nonatomic, assign) UserID rightAttenID;
@property (nonatomic, assign) NSInteger finalyWidth;
@property (nonatomic, assign) NSInteger finalyHeight;
@property (nonatomic, assign) BOOL GameHaveType;

@property (nonatomic, strong) TTCPGameCustomScollView *scrollView;
@property (nonatomic, strong) UILabel *prepareLabel;
@property (nonatomic, strong) UILabel *beginEnterGameLabel;

@property (nonatomic, strong) TTCPGameCustomView *contentView;

@property (nonatomic, strong) TTGameSelectView *selectView;
// 胜利的界面
@property (nonatomic, strong) UIImageView *victoryImageView;
@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) UIImageView *avaImageView;
@property (nonatomic, strong) UIButton *againGameBtn;
@property (nonatomic, strong) UIButton *changeGameBtn;
@property (nonatomic, strong) UILabel *gameNameLabel;

//  失败的界面 只有一个头像的差异
@property (nonatomic, strong) UIImageView *failImageView;

//  平局的界面  只有两个头像的差异
@property (nonatomic, strong) TTCustomAvatorImageView *leftImageView;
@property (nonatomic, strong) TTCustomAvatorImageView *rightImageView;

// 麦下观众的视角
@property (nonatomic, strong) UIButton *readyButton;
@property (nonatomic, strong) UIImageView *pkingImageView;

// 游戏结束，其中一方胜利的观众视角
@property (nonatomic, strong) YYLabel *nickNameLabel;
@property (nonatomic, strong) UIButton *attentionBtn;

// 观众观战
@property (nonatomic, strong) UIButton *watchingBtn;
@property (nonatomic, strong) UILabel *watchingLabel;

// 游戏结束 观众视角 平局 很麻烦
@property (nonatomic, strong) UIImageView *leftAudienceImageView;
@property (nonatomic, strong) UIImageView *rightAudienceImageView;
@property (nonatomic, strong) YYLabel *leftAudienceLabel;
@property (nonatomic, strong) YYLabel *rightAudienceLabel;
@property (nonatomic, strong) UIButton *leftAudienceBtn;
@property (nonatomic, strong) UIButton *rightAudienceBtn;


@property (nonatomic, strong) AVAudioPlayer *musicPlayer;
@property (nonatomic, strong) AVAudioPlayer *victoryPlayer;

@property (nonatomic, strong) TTCPGameCustomModel *cusmodel;
@end

@implementation TTCPGameView

static NSInteger customWidth = 107;
static NSInteger customHeight = 127;

static TTCPGameView *gameView;
static dispatch_once_t onceToken;

+ (instancetype)sharedGameView{
    
    dispatch_once(&onceToken, ^{
        gameView = [[self alloc] init];
        [gameView initView];
        [gameView addCore];
    });
    return gameView;
}

+ (void)attempDealloc{
    onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
    gameView = nil;
}

//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initView];
//        [self addCore];
//    }
//    return self;
//}

-(void)initView{
    self.finalyWidth = kScale(customWidth);
    self.finalyHeight = kScale(customHeight);
    
    [self layoutIfNeeded];
    self.backgroundColor = UIColorRGBAlpha(0x15163B, 0.6);
    
    [self addSubview:self.selectGameBtn];
    [self addSubview:self.cancelPrepareBtn];
    [self addSubview:self.acceptGameBtn];
    [self addSubview:self.refuseBtn];
    [self addSubview:self.prepareLabel];
    [self addSubview:self.beginEnterGameLabel];
    [self addSubview:self.readyButton];
    
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.attentionBtn];
    [self addSubview:self.watchingBtn];
    [self addSubview:self.watchingLabel];
    
    [self addSubview:self.inviteFriendBtn];
    [self addSubview:self.closeButton];
    
    //     游戏结束 胜利一方
    [self addSubview:self.victoryImageView];
    [self addSubview:self.gameNameLabel];
    [self addSubview:self.avatorImageView];
    [self.avatorImageView addSubview:self.avaImageView];
    [self addSubview:self.failImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.leftImageView];
    [self addSubview:self.changeGameBtn];
    [self addSubview:self.againGameBtn];
    [self addSubview:self.leftAudienceImageView];
    [self addSubview:self.rightAudienceImageView];
    [self addSubview:self.leftAudienceLabel];
    [self addSubview:self.rightAudienceLabel];
    [self addSubview:self.leftAudienceBtn];
    [self addSubview:self.rightAudienceBtn];
    [self addSubview:self.pkingImageView];
    
    self.GameHaveType = NO;
    [self getGameList];
}

- (void)getGameList{
    [[GetCore(CPGameCore) requestCPGameListWithoutType:[NSString stringWithFormat:@"%lld",GetCore(RoomCoreV2).getCurrentRoomInfo.uid] PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    } completed:^{
        
    }];;
}

-(void)addCore{
    AddCoreClient(CPGameCoreClient, self);
    AddCoreClient(PraiseCoreClient, self);
}

-(void)onCPRoomGetGameListWithoutType:(NSArray *)listArray{
    
    [self.datasourceArray removeAllObjects];
    [self.datasourceArray addObjectsFromArray:listArray];
    if (self.datasourceArray.count > 0) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (int i = 0; i < self.datasourceArray.count; i++) {
            [dataArray addObject:[self.datasourceArray[i] model2dictionary]];
        }
        
        GetCore(TTGameStaticTypeCore).privateMessageArray = dataArray;
    }
    
    if (self.contentView) {
        [self.contentView removeFromSuperview];
        self.contentView = nil;
    }
    self.contentView = [[TTCPGameCustomView alloc] initWithFrame:CGRectMake(0, 34, KScreenWidth, self.finalyHeight)];
    
    _contentView.backgroundColor = UIColor.clearColor;
    
    [self addSubview:self.contentView];
    
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
    }
    
    self.scrollView = [[TTCPGameCustomScollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, self.finalyWidth, self.finalyHeight);
    _scrollView.centerX = KScreenWidth / 2;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = UIColor.clearColor;
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    
    [self.contentView addSubview:self.scrollView];
    
    [self.contentView addSubview:self.selectView];
    
    for (int i = 0; i < self.datasourceArray.count; i++) {
        
        TTCPGameListItemView *itemView1 = [self viewWithTag:100 + i];
        if (itemView1) {
            [itemView1 removeFromSuperview];
            itemView1 = nil;
        }
        
        TTCPGameListItemView *itemView = [[TTCPGameListItemView alloc] initWithFrame:CGRectMake(self.finalyWidth * i, 0, self.finalyWidth, self.finalyHeight)];
        
        itemView.index = i;
        
        itemView.tag = 100 + i;
        
        CPGameListModel *model = self.datasourceArray[i];
        
        [itemView CPGameModel:model];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItemAction:)];
        
        [itemView addGestureRecognizer:tapGes];
        
        [_scrollView addSubview:itemView];
    }
    
    self.selectIndex = 0;
    
    _scrollView.contentSize = CGSizeMake(self.finalyWidth * self.datasourceArray.count, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    int row = 0;
    if (self.datasourceArray.count % 2 == 0) {
        row = self.datasourceArray.count / 2 - 1;
    }else{
        row = self.datasourceArray.count / 2;
    }
    _scrollView.contentOffset = CGPointMake(row * self.finalyWidth, 0);
    
    [self changeScrollViewOffset];
    
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    if (mineMember.type != NIMChatroomMemberTypeCreator) {
        self.inviteFriendBtn.hidden = YES;
        self.closeButton.hidden = YES;
    }
    
    if (self.GameHaveType == YES){
        self.GameHaveType = NO;
        for (int i = 0; i < self.datasourceArray.count; i++) {
            CPGameListModel *model = self.datasourceArray[i];
            if ([model.gameId isEqualToString:self.cusmodel.gameInfo.gameId]) {
                self.selectIndex = i;
                break;
            }
        }
        [self HaveChoiceGameOtherPartyUI];
        
        self.scrollView.contentOffset = CGPointMake(self.selectIndex * self.finalyWidth, 0);
    }
}

- (void)matchGameAndGameData:(CPGameListModel *)model{
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *launchGameModel = self.datasourceArray[i];
        if ([launchGameModel.gameName isEqualToString:model.gameName]) {
            self.selectIndex = i;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(self.selectIndex * self.finalyWidth, 0);
            }];
            break;
        }
    }
}


- (void)tapItemAction:(UITapGestureRecognizer *)ges{
    TTCPGameListItemView *view = (TTCPGameListItemView *)ges.view;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(view.index * self.finalyWidth, 0);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self changeScrollViewOffset];
}

- (void)changeScrollViewOffset{
    for (TTCPGameListItemView *subView in self.scrollView.subviews) {
        if (![subView isKindOfClass:TTCPGameListItemView.class]) {
            return;
        }
        CGFloat x = subView.frame.origin.x - self.scrollView.contentOffset.x;
        
        CGFloat scale = 0;
        
        //        self.finalyWidth = 118.128
        if (x < self.finalyWidth && x > -self.finalyWidth) {
            scale = 1 - fabs(x) / 1.0 / self.finalyWidth;
            self.selectIndex = subView.index;
            NSLog(@"%ld",self.selectIndex);
        }
        [subView resetFrame:scale];
    }
}


-(NSMutableArray *)datasourceArray{
    if (!_datasourceArray) {
        self.datasourceArray = [NSMutableArray array];
    }
    return _datasourceArray;
}

-(UIButton *)selectGameBtn{
    if (!_selectGameBtn) {
        self.selectGameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectGameBtn.size = CGSizeMake(90, 34);
        [_selectGameBtn setTitle:@"选择" forState:UIControlStateNormal];
        [_selectGameBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _selectGameBtn.top = 34 + self.finalyHeight + 8;
        _selectGameBtn.centerX = KScreenWidth / 2;
        
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _selectGameBtn.bounds;
        gradient.colors = @[(id)UIColorFromRGB(0x05C7C7).CGColor,(id)UIColorFromRGB(0x57EDC2).CGColor];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        [_selectGameBtn.layer addSublayer:gradient];
        
        _selectGameBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _selectGameBtn.layer.cornerRadius = 17;
        _selectGameBtn.layer.masksToBounds = YES;
        [_selectGameBtn addTarget:self action:@selector(selectGameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectGameBtn;
}



-(UIButton *)cancelPrepareBtn{
    if (!_cancelPrepareBtn) {
        self.cancelPrepareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelPrepareBtn.size = CGSizeMake(90, 34);
        [_cancelPrepareBtn setTitle:@"取消准备" forState:UIControlStateNormal];
        [_cancelPrepareBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _cancelPrepareBtn.backgroundColor = UIColor.clearColor;
        _cancelPrepareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelPrepareBtn.top = 34 + self.finalyHeight + 8;
        _cancelPrepareBtn.centerX = KScreenWidth / 2;
        _cancelPrepareBtn.layer.borderWidth = 1;
        _cancelPrepareBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        _cancelPrepareBtn.layer.masksToBounds = YES;
        _cancelPrepareBtn.layer.cornerRadius = 17;
        _cancelPrepareBtn.hidden = YES;
        [_cancelPrepareBtn addTarget:self action:@selector(cancelPrepareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelPrepareBtn;
}

#pragma mark --- 点击了选择游戏，此时游戏状态变为准备中 ---
- (void)selectGameAction:(UIButton *)sender{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    if (self.datasourceArray.count <= 0) {
        return;
    }
    __block BOOL gameNowBOOL = NO;
    CPGameListModel *model = self.datasourceArray[self.selectIndex];
    
    self.selectView.gameModel = model;
    
    @weakify(self);
    [[GetCore(CPGameCore) requestCPGameListWithSelectGame:[NSString stringWithFormat:@"%lld",GetCore(RoomCoreV2).getCurrentRoomInfo.uid] PageNum:1 PageSize:30] subscribeNext:^(id x) {
        [dataArray addObjectsFromArray:x];
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            for (int i = 0; i< dataArray.count; i++) {
                CPGameListModel *modelNow = dataArray[i];
                if ([modelNow.gameId isEqualToString:model.gameId]) {
                    gameNowBOOL = YES;
                }
            }
            if (gameNowBOOL) {
                [self HaveChoiceGameMyOwnUI];
                
                [[BaiduMobStat defaultStat]logEvent:@"roomcp_gamechose_ready_click" eventLabel:@"麦上用户发起按钮"];
                
                self.inviteFriendBtn.hidden = YES;
                
                [self selectGameWithRrefreshGameListSuccess:model];
                
            }else{
                [XCHUDTool showErrorWithMessage:@"该游戏已下架，请重新选择"];
                NotifyCoreClient(CPGameCoreClient, @selector(onCPRoomGetGameList:), onCPRoomGetGameList:x);
            }
        });
    } error:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];
    
}


- (void)selectGameWithRrefreshGameListSuccess:(CPGameListModel *)model{
    
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(ImRoomCoreV2).currentRoomInfo.uid WithGameStatus:3 GameId:model.gameId gameName:model.gameName StartUid:GetCore(AuthCore).getUid] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    } completed:^{
        
    }];
    
    TTCPGameCustomInfo *gameInfo;
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.roomGame) {
        gameInfo = [TTCPGameCustomInfo modelWithJSON:GetCore(ImRoomCoreV2).currentRoomInfo.roomGame];
    }else{
        gameInfo = [[TTCPGameCustomInfo alloc] init];
    }
    
    gameInfo.gameId = model.gameId;
    gameInfo.gameName = model.gameName;
    gameInfo.gameIcon = model.gameIcon;
    gameInfo.gameChannel = model.gameChannel;
    
    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
    cpAtt.gameInfo = gameInfo;
    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_CPGAME;
    attachement.second = Custom_Noti_Sub_CPGAME_Select;
    attachement.data = [cpAtt model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
    
    NSArray *array = [GetCore(RoomQueueCoreV2) findSendGiftMember];
    if (array.count < 2) {
        
        //  获取我自己在哪个麦位上
        NSInteger myPositonLocation = [[GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(AuthCore).getUid.userIDValue] intValue];
        
        // 如果我在-1 麦位上，取到的应该是空闲麦位0的信息。   反之。。。
        MicroState *state = [GetCore(ImRoomCoreV2).micQueue objectForKey:[NSString stringWithFormat:@"%ld", myPositonLocation = 0 ? -1 : 0]].microState;
        
        // 点击了选择中，游戏变为了准备中，此时麦上的人小于2个  房间加入匹配池
        if (GetCore(RoomCoreV2).getCurrentRoomInfo.limitType == nil || state.posState == MicroPosStateLock) {
            //  第一种情况是 房间设置了 进房限制，房间将不加入匹配池
            //   第二种情况是 房间的空闲麦位 上锁了。同样房间不加入匹配池
            return;
        }
        [[GetCore(CPGameCore) requestRoomJoinMatchPoolList:GetCore(AuthCore).getUid.userIDValue RoomID:[NSString stringWithFormat:@"%ld",GetCore(RoomCoreV2).getCurrentRoomInfo.roomId] GameId:model.gameId] subscribeError:^(NSError *error) {
            [XCHUDTool showErrorWithMessage:error.domain];
        }];
    }
    
}

/*
 
 两个麦上都有人了移出匹配池
 
 */
- (void)RemovedFromMatchPool{
    if (self.datasourceArray.count <= 0) {
        return;
    }
    CPGameListModel *model = self.datasourceArray[self.selectIndex];
    [[GetCore(CPGameCore) requestRoomExitMatchPoolList:GetCore(AuthCore).getUid.userIDValue RoomID:[NSString stringWithFormat:@"%ld",GetCore(RoomCoreV2).getCurrentRoomInfo.roomId] GameId:model.gameId] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];
}

-(void)cancelPrepareAction{
    
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    if (mineMember.type == NIMChatroomMemberTypeCreator) {
        _inviteFriendBtn.hidden = NO;
        _closeButton.hidden = NO;
    }else{
        _inviteFriendBtn.hidden = YES;
        _closeButton.hidden = YES;
    }
    
    [self HaveNoChoiceGameUI];
    
    NSArray *postionArray = [GetCore(RoomQueueCoreV2) findSendGiftMember];
    if (postionArray.count < 2) {
        [self RemovedFromMatchPool];
    }
    
    // 取消了准备， 游戏变为选择中
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(ImRoomCoreV2).currentRoomInfo.uid WithGameStatus:2 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];;
    
    CPGameListModel *model = self.datasourceArray[self.selectIndex];
    TTCPGameCustomInfo *gameInfo;
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.roomGame) {
        gameInfo = [TTCPGameCustomInfo modelWithJSON:GetCore(ImRoomCoreV2).currentRoomInfo.roomGame];
    }else{
        gameInfo = [[TTCPGameCustomInfo alloc] init];
    }
    
    gameInfo.gameId = model.gameId;
    gameInfo.gameName = model.gameName;
    gameInfo.gameIcon = model.gameIcon;
    gameInfo.gameChannel = model.gameChannel;
    
    
    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
    cpAtt.gameInfo = gameInfo;
    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_CPGAME;
    attachement.second = Custom_Noti_Sub_CPGAME_Cancel_Prepare;
    attachement.data = [cpAtt model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}

- (void)downMicWithGameSeleter {
    // 取消了准备， 游戏变为选择中
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(ImRoomCoreV2).currentRoomInfo.uid WithGameStatus:2 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];;
    
    CPGameListModel *model = self.datasourceArray[self.selectIndex];
    TTCPGameCustomInfo *gameInfo;
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.roomGame) {
        gameInfo = [TTCPGameCustomInfo modelWithJSON:GetCore(ImRoomCoreV2).currentRoomInfo.roomGame];
    }else{
        gameInfo = [[TTCPGameCustomInfo alloc] init];
    }
    
    gameInfo.gameId = model.gameId;
    gameInfo.gameName = model.gameName;
    gameInfo.gameIcon = model.gameIcon;
    gameInfo.gameChannel = model.gameChannel;
    
    
    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
    cpAtt.gameInfo = gameInfo;
    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_CPGAME;
    attachement.second = Custom_Noti_Sub_CPGAME_Cancel_Prepare;
    attachement.data = [cpAtt model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}


#pragma mark --- 懒加载 ---
- (UIButton *)inviteFriendBtn{
    if (!_inviteFriendBtn) {
        _inviteFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteFriendBtn.backgroundColor = UIColorRGBAlpha(0xffffff, 0.1);
        [_inviteFriendBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
        [_inviteFriendBtn setTitleColor:UIColorRGBAlpha(0x56ECC2, 0.8) forState:UIControlStateNormal];
        _inviteFriendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _inviteFriendBtn.layer.cornerRadius = 12;
        _inviteFriendBtn.left = 10;
        _inviteFriendBtn.top = 10;
        _inviteFriendBtn.size = CGSizeMake(70, 24);
        [_inviteFriendBtn addTarget:self action:@selector(inviteFriendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteFriendBtn;
}

// 邀请好友
- (void)inviteFriendBtnAction:(UIButton *)sender{
    [[BaiduMobStat defaultStat]logEvent:@"roomcp_gamechose_inv_click" eventLabel:@"游戏选择面板-邀请好友按钮"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"inviteFri" forKey:@"inviteFriend"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NotifyCoreClient(CPGameCoreClient, @selector(inviteFriendFromGameModel), inviteFriendFromGameModel);
}

// 关闭游戏模式
- (void)closeGameModelBtnAction:(UIButton *)sender{
    
    if ([GetCore(RoomCoreV2).getCurrentRoomInfo.roomGame[@"status"] intValue] == 3) {
        [[BaiduMobStat defaultStat]logEvent:@"roomcp_gamematching_clo_click" eventLabel:@"游戏等待面板-房主关闭按钮"];
    }else{
        [[BaiduMobStat defaultStat]logEvent:@"roomcp_gamechose_close_click" eventLabel:@"游戏选择面板-房主关闭按钮"];
    }
    NotifyCoreClient(CPGameCoreClient, @selector(closeGameModel), closeGameModel);
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = UIColorRGBAlpha(0xffffff, 0.1);
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:UIColorRGBAlpha(0xFFFEFE, 0.8) forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _closeButton.layer.cornerRadius = 12;
        _closeButton.size = CGSizeMake(50, 24);
        _closeButton.right = KScreenWidth - 14;
        _closeButton.top = 10;
        [_closeButton addTarget:self action:@selector(closeGameModelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark --- 麦下观众UI ---
-(UIButton *)readyButton{
    if (!_readyButton) {
        self.readyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _readyButton.size = CGSizeMake(kScale(100), 34);
        [_readyButton setTitle:@"立即准备" forState:UIControlStateNormal];
        [_readyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _readyButton.top = 34 + self.finalyHeight + 8;
        _readyButton.centerX = KScreenWidth / 2;
        _readyButton.hidden = YES;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _readyButton.bounds;
        gradient.colors = @[(id)UIColorFromRGB(0x05C7C7).CGColor,(id)UIColorFromRGB(0x57EDC2).CGColor];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        [_readyButton.layer addSublayer:gradient];
        
        _readyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _readyButton.layer.cornerRadius = 17;
        _readyButton.layer.masksToBounds = YES;
        [_readyButton addTarget:self action:@selector(readyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readyButton;
}

-(UIImageView *)pkingImageView{
    if (!_pkingImageView) {
        self.pkingImageView = [[UIImageView alloc] init];
        _pkingImageView.image = [UIImage imageNamed:@"room_cpGame_pkIng"];
        _pkingImageView.size = CGSizeMake(kScale(76), 15);
        _pkingImageView.centerX = KScreenWidth / 2;
        _pkingImageView.hidden = YES;
    }
    return _pkingImageView;
}

-(void)readyButtonAction:(UIButton *)sender{
    [[BaiduMobStat defaultStat]logEvent:@"roomcp_gamematching_rea_click" eventLabel:@"游戏等待面板-麦下用户准备按钮"];
    
    NSString *homeownersID = [GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid];
    
    NSInteger otherId = 0;
    if ([homeownersID integerValue] == -1) {
        otherId = 0;
    }else{
        otherId = -1;
    }
    
    if (self.cusmodel) {
        self.selectView.model = self.cusmodel;
    } else {
        self.selectView.gameModel = self.datasourceArray[self.selectIndex];
    }
    
    MicroState *state = [GetCore(ImRoomCoreV2).micQueue objectForKey:[NSString stringWithFormat:@"%ld",otherId]].microState;
    
    if (![GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]) {
        if (state.posState == MicroPosStateLock) {
            [XCHUDTool showErrorWithMessage:@"需要上麦才能玩游戏哦"];
        }else{
            [GetCore(RoomQueueCoreV2) upFreeMic];
        }
    }
}

-(void)audienceCanSeeGameAction:(nullable TTCPGameCustomModel *)returnModel{
    [self HaveNoChoiceGameUIForTourists];
}

-(void)audienceCanReadyGameAction:(nullable TTCPGameCustomModel *)returnModel{
    [self HaveChoiceGameUIForTourists];
    if (returnModel) {
        self.cusmodel = returnModel;
        for (int i = 0; i < self.datasourceArray.count; i++) {
            CPGameListModel *model = self.datasourceArray[i];
            if ([model.gameId isEqualToString:returnModel.gameInfo.gameId]) {
                self.selectIndex = i;
                self.selectView.gameModel = model;
                break;
            } else {
                [self HaveNoChoiceGameUIForTourists];
            }
        }
    }else{
        if (GetCore(RoomCoreV2).getCurrentRoomInfo.roomGame) {
            for (int i = 0; i < self.datasourceArray.count; i++) {
                CPGameListModel *model = self.datasourceArray[i];
                if ([model.gameId isEqualToString:GetCore(RoomCoreV2).getCurrentRoomInfo.roomGame[@"gameId"]]) {
                    self.selectIndex = i;
                    self.selectView.gameModel = model;
                    break;
                } else {
                    [self HaveNoChoiceGameUIForTourists];
                }
            }
        }
    }
}

//  游戏开始  麦下观众的视角
-(void)gameBeginAudienceCanSeeGameAction{
    
    [self HaveChoiceGameAndStartUIForTourists];
    
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = self.datasourceArray[i];
        if ([model.gameId isEqualToString:GetCore(RoomCoreV2).getCurrentRoomInfo.roomGame[@"gameId"]]) {
            _gameNameLabel.text = [NSString stringWithFormat:@"- %@ -",model.gameName];
            [_gameNameLabel sizeToFit];
            _gameNameLabel.centerX = KScreenWidth / 2;
            _gameNameLabel.top = 27;
            break;
        }
    }
    
    _leftImageView.top = _gameNameLabel.bottom + 28;
    _rightImageView.top = _leftImageView.top;
    
    _pkingImageView.centerY = _leftImageView.centerY;
    
    NSArray *array = [GetCore(RoomQueueCoreV2) findSendGiftMember];
    for (int i = 0; i < array.count; i++) {
        ChatRoomMicSequence *sequence = array[i];
        if (i == 0) {
            [_leftImageView qn_setImageImageWithUrl:sequence.userInfo.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            _leftImageView.maskImageView.hidden = NO;
        }else{
            [_rightImageView qn_setImageImageWithUrl:sequence.userInfo.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
            _rightImageView.maskImageView.hidden = NO;
        }
    }
}

#pragma mark --- 当其中一个人异常退出时。这个人的界面默认就是选择游戏界面，不管是什么异常 ---
- (void)gameOverForAbnormalReturnSelectPage{
    [self refuseAction];
}

#pragma mark --- 游戏结束返回时 麦下观众视角 其中一方胜利了 ---
-(void)gameOverAudienceCanSeeGameAction:(TTCPGameCustomModel *)customModel{
    
    [self gameOverAndOnePartyWonUIForTourists];
    
    self.victoryImageView.image = [UIImage imageNamed:@"room_cp_game_victory"];
    
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = self.datasourceArray[i];
        if ([model.gameId isEqualToString:customModel.gameResultInfo.gameId]) {
            _gameNameLabel.text = [NSString stringWithFormat:@"- %@ -",model.gameName];
            [_gameNameLabel sizeToFit];
            _gameNameLabel.centerX = KScreenWidth / 2;
            
            _avatorImageView.top = _gameNameLabel.bottom + 9;
        }
    }
    NSString *avatorString = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.winners safeObjectAtIndex:0][@"uid"] userIDValue]] avatar];
    
    [_avaImageView qn_setImageImageWithUrl:avatorString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    
    NSString *nickString = [GetCore(UserCore) getUserInfoInDB:[[[customModel.gameResultInfo.winners safeObjectAtIndex:0] objectForKey:@"uid"] userIDValue]].nick;
    
    UserGender gender = [GetCore(UserCore) getUserInfoInDB:[[[customModel.gameResultInfo.winners safeObjectAtIndex:0] objectForKey:@"uid"] userIDValue]].gender;
    
    self.nickNameLabel.attributedText = [self createNickAttributeString:nickString Gender:gender];
    
    _nickNameLabel.top = _avatorImageView.bottom + 10;
    _nickNameLabel.width = kScale(100);
    _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    _nickNameLabel.centerX = KScreenWidth / 2;
    
    @weakify(self)
    [GetCore(PraiseCore) isUid:GetCore(AuthCore).getUid.userIDValue isLikeUid:[[[customModel.gameResultInfo.winners safeObjectAtIndex:0] objectForKey:@"uid"] userIDValue]
                       success:^(BOOL isLike) {
                           @strongify(self)
                           self.attention = isLike;
                           if (self.attention) {
                               self.attentionBtn.hidden = YES;
                           }else{
                               self.attenId = [[[customModel.gameResultInfo.winners safeObjectAtIndex:0] objectForKey:@"uid"] userIDValue];
                               self.attentionBtn.hidden = NO;
                           }
                       }];
    
    _attentionBtn.top = _nickNameLabel.bottom + 10;
    
}

//create mic+nick+gender
- (NSMutableAttributedString *)createNickAttributeString:(NSString *)nickString Gender:(UserGender )gender{
    CGFloat fontSize = 12.0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    //nick
    NSMutableAttributedString *nickLabelString = [self createNickLabel:nickString fontSize:fontSize];
    //gender
    NSMutableAttributedString *genderString = [self createGenderAttr:gender];
    
    [attributedString appendAttributedString:nickLabelString];
    [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    [attributedString appendAttributedString:genderString];
    
    return attributedString;
}

- (NSMutableAttributedString *)createNickLabel:(NSString *)userNick fontSize:(CGFloat)fontSize{
    
    UILabel *nickLabel = [[UILabel alloc]init];
    //text
    NSString *nick = userNick;
    
    nickLabel.text = nick;
    nickLabel.font = [UIFont systemFontOfSize:fontSize];
    
    nickLabel.textColor = UIColorRGBAlpha(0xffffff, 1.0);
    
    //width
    CGFloat nickWidth = [self sizeWithText:nick font:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(KScreenWidth , KScreenHeight)].width;
    CGFloat maxWidth = 70;
    if (nickWidth > maxWidth) {
        nickLabel.bounds = CGRectMake(0, 0, maxWidth, 14);
    }else {
        nickLabel.bounds = CGRectMake(0, 0, nickWidth+6, 14);
    }
    
    NSMutableAttributedString * nickString = [NSMutableAttributedString yy_attachmentStringWithContent:nickLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nickLabel.frame.size.width, nickLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:fontSize] alignment:YYTextVerticalAlignmentCenter];
    return nickString;
}

//create gender
- (NSMutableAttributedString *)createGenderAttr:(UserGender )gender{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.bounds = CGRectMake(0, 0, 13, 13);;
    imageView.contentMode = UIViewContentModeScaleToFill;
    NSString *imageName = @"";
    if (gender == 1) {
        imageName = [[XCTheme defaultTheme] common_sex_male];
    }else{
        imageName = [[XCTheme defaultTheme] common_sex_female];
    }
    imageView.image = [UIImage imageNamed:imageName];
    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return imageString;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)watchGameAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    NSArray *array = [GetCore(RoomQueueCoreV2) findSendGiftMember];
    UserID leftUid = 0;
    UserID rightUid = 0;
    for (int i = 0; i < array.count; i++) {
        ChatRoomMicSequence *sequence = array[i];
        if (i == 0) {
            leftUid = sequence.userInfo.uid;
        }
        
        if (i == 1) {
            rightUid = sequence.userInfo.uid;
        }
    }
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = self.datasourceArray[i];
        if ([model.gameId isEqualToString:GetCore(RoomCoreV2).getCurrentRoomInfo.roomGame[@"gameId"]]) {
            [[GetCore(CPGameCore) requestWatchGameUrlUid:GetCore(AuthCore).getUid.userIDValue Roomid:GetCore(RoomCoreV2).getCurrentRoomInfo.roomId GameId:model.gameId ChannelId:model.gameChannel UidLeft:leftUid UidRight:rightUid] subscribeError:^(NSError *error) {
                [XCHUDTool showErrorWithMessage:error.domain];
                sender.userInteractionEnabled = YES;
            } completed:^{
                sender.userInteractionEnabled = YES;
            }];
            break;
        }
    }
}

- (void)attenBtnActon:(UIButton *)sender{
    if (!self.attention) {
        [[BaiduMobStat defaultStat]logEvent:@"roomcp_gameover_follow_click" eventLabel:@"关注"];
        NSString * mine = [GetCore(AuthCore) getUid];

        [XCHUDTool showSuccessWithMessage:@"关注成功"];

        [GetCore(PraiseCore) praise:mine.userIDValue bePraisedUid:self.attenId];
        sender.hidden = YES;
    }
}

#pragma mark -- 麦下观众视角。平局 ---
- (void)gameOverAndICanNotWatchWhoWin:(TTCPGameCustomModel *)customModel{
    
    [self gameOverAndDrawUIForTourists];
    
    self.victoryImageView.image = [UIImage imageNamed:@"room_cp_game_draw"];
    
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = self.datasourceArray[i];
        if ([model.gameId isEqualToString:customModel.gameResultInfo.gameId]) {
            _gameNameLabel.text = [NSString stringWithFormat:@"- %@ -",model.gameName];
            [_gameNameLabel sizeToFit];
            _gameNameLabel.centerX = KScreenWidth / 2;
            
            _leftAudienceImageView.top = _gameNameLabel.bottom + 30;
            _rightAudienceImageView.top = _leftAudienceImageView.top;
        }
    }
    NSString *leftAvatorString = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.users safeObjectAtIndex:0][@"uid"] userIDValue]] avatar];
    
    NSString *rightAvatorString = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.users safeObjectAtIndex:1][@"uid"] userIDValue]] avatar];
    
    [_leftAudienceImageView qn_setImageImageWithUrl:leftAvatorString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    
    [_rightAudienceImageView qn_setImageImageWithUrl:rightAvatorString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    
    NSString *leftNick = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.users safeObjectAtIndex:0][@"uid"] userIDValue]] nick];
    
    UserGender leftGender = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.users safeObjectAtIndex:0][@"uid"] userIDValue]] gender];
    
    NSString *rightNick = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.users safeObjectAtIndex:1][@"uid"] userIDValue]] nick];
    
    UserGender rightGender = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.users safeObjectAtIndex:1][@"uid"] userIDValue]] gender];
    
    _leftAudienceLabel.attributedText = [self createNickAttributeString:leftNick Gender:leftGender];
    _leftAudienceLabel.top = _leftAudienceImageView.bottom + 10;
    _leftAudienceLabel.width = kScale(100);
    _leftAudienceLabel.textAlignment = NSTextAlignmentCenter;
    _leftAudienceLabel.centerX = _leftAudienceImageView.centerX;
    
    _rightAudienceLabel.attributedText = [self createNickAttributeString:rightNick Gender:rightGender];
    _rightAudienceLabel.top = _rightAudienceImageView.bottom + 10;
    _rightAudienceLabel.width = kScale(100);
    _rightAudienceLabel.textAlignment = NSTextAlignmentCenter;
    _rightAudienceLabel.centerX = _rightAudienceImageView.centerX;
    
    @weakify(self)
    [GetCore(PraiseCore) isUid:GetCore(AuthCore).getUid.userIDValue isLikeUid:[[customModel.gameResultInfo.users safeObjectAtIndex:0][@"uid"] userIDValue] success:^(BOOL isLike) {
        @strongify(self)
        self.leftAttention = isLike;
        if (self.leftAttention) {
            self.leftAudienceBtn.hidden = YES;
        }else{
            self.leftAudienceBtn.hidden = NO;
            self.leftAttenID = [[customModel.gameResultInfo.users safeObjectAtIndex:0][@"uid"] userIDValue];
        }
    }];
    
    _leftAudienceBtn.top = _leftAudienceLabel.bottom + 10;
    _leftAudienceBtn.centerX = _leftAudienceImageView.centerX;
    
    [GetCore(PraiseCore) isUid:GetCore(AuthCore).getUid.userIDValue isLikeUid:[[customModel.gameResultInfo.users safeObjectAtIndex:1][@"uid"] userIDValue] success:^(BOOL isLike) {
        @strongify(self)
        self.rightAttention = isLike;
        if (self.rightAttention) {
            self.rightAudienceBtn.hidden = YES;
        }else{
            self.rightAudienceBtn.hidden = NO;
            self.rightAttenID = [[customModel.gameResultInfo.users safeObjectAtIndex:1][@"uid"] userIDValue];
        }
    }];
    
    _rightAudienceBtn.top = _rightAudienceLabel.bottom + 10;
    _rightAudienceBtn.centerX = _rightAudienceImageView.centerX;
}

//  当有一人在房间内开启匹配。另一人在房间外，匹配成功之后，由房间外的人进入房间并且发送一条云信自定义消息，告诉房间里面的人游戏开始了
- (void)enterRoomFromForInRoomMatch:(NSString *)gameString{
    
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = self.datasourceArray[i];
        if ([model.gameId isEqualToString:GetCore(ImRoomCoreV2).currentRoomInfo.roomGame[@"gameId"]]) {
            self.selectIndex = i;
            break;
        }
    }
    CPGameListModel *model = self.datasourceArray[self.selectIndex];
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(ImRoomCoreV2).currentRoomInfo.uid WithGameStatus:5 GameId:model.gameId gameName:model.gameName StartUid:GetCore(AuthCore).getUid] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];;
    
    
    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelWithJSON:GetCore(ImRoomCoreV2).currentRoomInfo.roomGame];
    
    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
    cpAtt.gameInfo = gameInfo;
    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    cpAtt.gameUrlString = gameString;
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_CPGAME;
    attachement.second = Custom_Noti_Sub_CPGAME_Start; // 跟随安卓 实际还要调
    attachement.data = [cpAtt model2dictionary];
    
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}

#pragma mark --- 麦上用户UI ---
#pragma mark --- 开启游戏面板，未选择游戏 和 对方UI 一样 ---
#pragma mark --- 选择了游戏，对面拒绝的UI ---
- (void)HaveNoChoiceGameUI{
    [self BeforeGameStartForTourists];
    [self BeforeGameStart];
    self.selectGameBtn.hidden = NO;
    
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
    
    self.selectView.hidden = YES;
    self.scrollView.hidden = NO;
}

#pragma mark --- 开启游戏面板，点击了选择的一方 UI  ---
- (void)HaveChoiceGameMyOwnUI{
    
    GetCore(TTGameStaticTypeCore).selectGameForMe = YES;
    
    [self BeforeGameStartForTourists];
    [self BeforeGameStart];
    self.cancelPrepareBtn.hidden = NO;
    
    self.selectView.hidden = NO;
    self.scrollView.hidden = YES;
}

#pragma mark --- 开启游戏面板，点击了选择的 对方UI  ---
- (void)HaveChoiceGameOtherPartyUI{
    
//    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
    
    [self BeforeGameStartForTourists];
    [self BeforeGameStart];
    self.acceptGameBtn.hidden = NO;
    self.refuseBtn.hidden = NO;
    
    self.selectView.hidden = NO;
    self.scrollView.hidden = YES;
}

#pragma mark --- 选择了游戏，对方同意的UI ---
- (void)HaveChoiceGameAndOtherPartyAcceptUI{
    
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
    
    [self BeforeGameStartForTourists];
    [self BeforeGameStart];
    self.prepareLabel.hidden = NO;
    self.beginEnterGameLabel.hidden = NO;
    
    self.selectView.hidden = NO;
    self.scrollView.hidden = YES;
}

#pragma mark --- 游戏结束，其中一方胜利的UI ---
- (void)GameOverAndOnePartyWonGameUI{
    
    [self BeforeGameStartForTourists];
    [self BeforeGameStart];
    self.victoryImageView.hidden = NO;
    self.gameNameLabel.hidden = NO;
    
    self.avaImageView.hidden = NO;
    self.avatorImageView.hidden = NO;
    
    self.againGameBtn.hidden = NO;
    self.changeGameBtn.hidden = NO;
    
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
    self.selectView.hidden = YES;
    self.scrollView.hidden = YES;
}

#pragma mark --- 游戏结束，其中一方失败的UI ---
- (void)GameOverAndOnePartyFailureGameUI {
    
    [self BeforeGameStartForTourists];
    [self BeforeGameStart];
    self.victoryImageView.hidden = NO;
    self.gameNameLabel.hidden = NO;
    
    self.failImageView.hidden = NO;
    
    self.againGameBtn.hidden = NO;
    self.changeGameBtn.hidden = NO;
    
    self.selectView.hidden = YES;
    self.scrollView.hidden = YES;
    
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
}

#pragma mark ---  游戏结束，平局的UI ---
- (void)GameOverAndDrawGameUI {
    [self BeforeGameStartForTourists];
    [self BeforeGameStart];
    self.victoryImageView.hidden = NO;
    self.gameNameLabel.hidden = NO;
    
    self.leftImageView.hidden = NO;
    self.rightImageView.hidden = NO;
    
    self.againGameBtn.hidden = NO;
    self.changeGameBtn.hidden = NO;
    
    self.selectView.hidden = YES;
    self.scrollView.hidden = YES;
    
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
}

#pragma mark --- 麦上人的总UI ---
- (void)BeforeGameStart {
    self.selectGameBtn.hidden = YES;
    self.cancelPrepareBtn.hidden = YES;
    
    self.acceptGameBtn.hidden = YES;
    self.refuseBtn.hidden = YES;
    
    self.prepareLabel.hidden = YES;
    self.beginEnterGameLabel.hidden = YES;
    
    self.victoryImageView.hidden = YES;
    self.gameNameLabel.hidden = YES;
    self.avaImageView.hidden = YES;
    self.avatorImageView.hidden = YES;
    
    self.failImageView.hidden = YES;
    self.changeGameBtn.hidden = YES;
    self.againGameBtn.hidden = YES;
    
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    if (mineMember.type == NIMChatroomMemberTypeCreator) {
        self.inviteFriendBtn.hidden = NO;
        self.closeButton.hidden = NO;
    }
}

#pragma mark --- 麦下人的UI ---
#pragma mark --- 开启游戏面板，未选择游戏 麦下的UI ---
- (void)HaveNoChoiceGameUIForTourists {
    [self BeforeGameStart];
    [self BeforeGameStartForTourists];
    self.watchingLabel.hidden = NO;
    
    self.scrollView.hidden = NO;
    self.selectView.hidden = YES;
    self.contentView.userInteractionEnabled = YES;
    
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
}

#pragma mark --- 开启游戏面板，选择了游戏 麦下的UI ---
- (void)HaveChoiceGameUIForTourists {
    [self BeforeGameStart];
    [self BeforeGameStartForTourists];
    // 分两种情况，一种是麦上都有人
    if ([GetCore(RoomQueueCoreV2) findSendGiftMember].count == 2){
        self.watchingLabel.hidden = NO;
    }else{
        // 一种是有空闲麦
        self.readyButton.hidden = NO;
    }
    
    self.selectView.hidden = NO;
    self.scrollView.hidden = YES;
    self.contentView.userInteractionEnabled = NO;
    
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
}

#pragma mark --- 开始了游戏 麦下的UI ---
- (void)HaveChoiceGameAndStartUIForTourists {
    [self BeforeGameStart];
    [self BeforeGameStartForTourists];
    self.gameNameLabel.hidden = NO;
    self.leftImageView.hidden = NO;
    self.rightImageView.hidden = NO;
    self.pkingImageView.hidden = NO;
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.watchingBtn.hidden = NO;
    //    });
    
    self.selectView.hidden = YES;
    self.scrollView.hidden = YES;
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
}

#pragma mark --- 游戏结束，其中一方胜利 麦下的UI ---
- (void)gameOverAndOnePartyWonUIForTourists {
    [self BeforeGameStart];
    [self BeforeGameStartForTourists];
    self.victoryImageView.hidden = NO;
    self.gameNameLabel.hidden = NO;
    self.avatorImageView.hidden = NO;
    self.avaImageView.hidden = NO;
    self.nickNameLabel.hidden = NO;
    self.attentionBtn.hidden = NO;
    
    self.selectView.hidden = YES;
    self.scrollView.hidden = YES;
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
}

#pragma mark --- 游戏结束，平局 麦下的UI ---
- (void)gameOverAndDrawUIForTourists {
    [self BeforeGameStart];
    [self BeforeGameStartForTourists];
    self.victoryImageView.hidden = NO;
    self.gameNameLabel.hidden = NO;
    self.leftAudienceImageView.hidden = NO;
    self.leftAudienceLabel.hidden = NO;
    self.leftAudienceBtn.hidden = NO;
    
    self.rightAudienceImageView.hidden = NO;
    self.rightAudienceLabel.hidden = NO;
    self.rightAudienceBtn.hidden = NO;
    
    self.selectView.hidden = YES;
    self.scrollView.hidden = YES;
    GetCore(TTGameStaticTypeCore).selectGameForMe = NO;
}

#pragma mark --- 麦下人的总UI ---
- (void)BeforeGameStartForTourists {
    self.watchingLabel.hidden = YES;
    self.readyButton.hidden = YES;
    self.leftImageView.hidden = YES;
    self.rightImageView.hidden = YES;
    self.pkingImageView.hidden = YES;
    self.watchingBtn.hidden = YES;
    
    self.leftAudienceImageView.hidden = YES;
    self.leftAudienceLabel.hidden = YES;
    self.leftAudienceBtn.hidden = YES;
    
    self.rightAudienceImageView.hidden = YES;
    self.rightAudienceLabel.hidden = YES;
    self.rightAudienceBtn.hidden = YES;
    
    self.attentionBtn.hidden = YES;
    self.nickNameLabel.hidden = YES;
    
    self.inviteFriendBtn.hidden = YES;
    self.closeButton.hidden = YES;
}

//  选择游戏
-(void)selectGameAciton:(TTCPGameCustomModel *)returnModel {
    
    self.selectView.model = returnModel;
    [self HaveChoiceGameOtherPartyUI];
    self.cusmodel = returnModel;
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = self.datasourceArray[i];
        if ([model.gameId isEqualToString:returnModel.gameInfo.gameId]) {
            self.selectIndex = i;
            self.GameHaveType = NO;
            break;
        }else{
            self.GameHaveType = YES;
        }
    }
    if (self.GameHaveType == NO) {
    }else{
        [self getGameList];
    }
}

//  拒绝游戏
-(void)refuseAction {
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    if (mineMember.type == NIMChatroomMemberTypeCreator) {
        _inviteFriendBtn.hidden = NO;
        _closeButton.hidden = NO;
    }else{
        _inviteFriendBtn.hidden = YES;
        _closeButton.hidden = YES;
    }
    
    [self HaveNoChoiceGameUI];
    
}

//  进入游戏
-(void)acceptGameBeginActionWithModel:(TTCPGameCustomModel *)model {
    [self HaveChoiceGameAndOtherPartyAcceptUI];
    
    // 接受了游戏。请求当前游戏链接
//    CPGameListModel *model = self.datasourceArray[self.selectIndex];
    
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(ImRoomCoreV2).currentRoomInfo.uid WithGameStatus:5 GameId:model.gameInfo.gameId gameName:model.gameInfo.gameName StartUid:GetCore(AuthCore).getUid] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];;
    
    [GetCore(CPGameCore) requestGameUrlUid:GetCore(AuthCore).getUid.userIDValue Name:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick Roomid:GetCore(RoomCoreV2).getCurrentRoomInfo.roomId GameId:model.gameInfo.gameId ChannelId:model.gameInfo.gameChannel AiUId:0];
}

-(UIButton *)acceptGameBtn {
    if (!_acceptGameBtn) {
        self.acceptGameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _acceptGameBtn.size = CGSizeMake(90, 34);
        [_acceptGameBtn setTitle:@"接受" forState:UIControlStateNormal];
        [_acceptGameBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        _acceptGameBtn.top = 34 + self.finalyHeight + 8;
        _acceptGameBtn.left = KScreenWidth / 2 + 12;
        _acceptGameBtn.hidden = YES;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _acceptGameBtn.bounds;
        gradient.colors = @[(id)UIColorFromRGB(0x05C7C7).CGColor,(id)UIColorFromRGB(0x57EDC2).CGColor];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        [_acceptGameBtn.layer addSublayer:gradient];
        
        _acceptGameBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _acceptGameBtn.layer.cornerRadius = 17;
        _acceptGameBtn.layer.masksToBounds = YES;
        [_acceptGameBtn addTarget:self action:@selector(acceptGameAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _acceptGameBtn;
}

//  接受游戏
-(void)acceptGameAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [[BaiduMobStat defaultStat]logEvent:@"roomcp_gamematching_acc_click" eventLabel:@"游戏等待面板-麦上用户接受按钮"];
    // 点击了接受了游戏，进入已准备 改变后台游戏状态
//    CPGameListModel *model = self.datasourceArray[self.selectIndex];
//    self.cusmodel
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(ImRoomCoreV2).currentRoomInfo.uid WithGameStatus:5 GameId:self.cusmodel.gameInfo.gameId gameName:self.cusmodel.gameInfo.gameName StartUid:GetCore(AuthCore).getUid] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];;
    
    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
    cpAtt.gameInfo = self.cusmodel.gameInfo;
    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_CPGAME;
    attachement.second = Custom_Noti_Sub_CPGAME_Start; // 跟随安卓 实际还要调
    attachement.data = [cpAtt model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
    
    [self acceptGameBeginActionWithModel:self.cusmodel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.acceptGameBtn.userInteractionEnabled = YES;
    });
    
}


-(void)refuseBtnAction:(UIButton *)sender {
    [[BaiduMobStat defaultStat]logEvent:@"roomcp_gamematching_ref_click" eventLabel:@"游戏等待面板-麦上用户拒绝按钮"];
    // 取消了准备， 游戏变为选择中
    
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(ImRoomCoreV2).currentRoomInfo.uid WithGameStatus:2 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];;
    
    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
    cpAtt.gameInfo = self.cusmodel.gameInfo;
    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_CPGAME;
    attachement.second = Custom_Noti_Sub_CPGAME_Cancel_Prepare;
    attachement.data = [cpAtt model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
    
    [self refuseAction];
}

-(UIButton *)refuseBtn {
    if (!_refuseBtn) {
        self.refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refuseBtn.size = CGSizeMake(90, 34);
        [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _refuseBtn.backgroundColor = UIColor.clearColor;
        _refuseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _refuseBtn.top = 34 + self.finalyHeight + 8;
        _refuseBtn.right = KScreenWidth / 2 - 12;
        _refuseBtn.layer.borderWidth = 1;
        _refuseBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        _refuseBtn.layer.masksToBounds = YES;
        _refuseBtn.layer.cornerRadius = 17;
        _refuseBtn.hidden = YES;
        [_refuseBtn addTarget:self action:@selector(refuseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refuseBtn;
}

-(UILabel *)prepareLabel {
    if (!_prepareLabel) {
        self.prepareLabel = [[UILabel alloc] init];
        _prepareLabel.text = @"玩家已准备（2/2）";
        _prepareLabel.textColor = UIColorFromRGB(0xffffff);
        _prepareLabel.font = [UIFont systemFontOfSize:15];
        _prepareLabel.top = 34 + self.finalyHeight + 8;
        [_prepareLabel sizeToFit];
        _prepareLabel.hidden = YES;
        _prepareLabel.centerX = KScreenWidth / 2;
    }
    return _prepareLabel;
}

-(UILabel *)beginEnterGameLabel {
    if (!_beginEnterGameLabel) {
        self.beginEnterGameLabel = [[UILabel alloc] init];
        _beginEnterGameLabel.text = @"开始进入游戏";
        _beginEnterGameLabel.textColor = UIColorRGBAlpha(0xffffff, 0.5);
        _beginEnterGameLabel.font = [UIFont systemFontOfSize:12];
        _beginEnterGameLabel.top = _prepareLabel.bottom + 7;
        [_beginEnterGameLabel sizeToFit];
        _beginEnterGameLabel.hidden = YES;
        _beginEnterGameLabel.centerX = KScreenWidth / 2;
    }
    return _beginEnterGameLabel;
}

#pragma mark ---- 游戏结束 胜利一方的UI ----
-(void)gameOverAndWuSueecss:(NSDictionary *)relustDict {
    
    NSURL *musicUrlString = [[NSBundle mainBundle] URLForResource:@"win" withExtension:@"wav"];
    
    self.victoryPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrlString error:nil];
    [self.victoryPlayer play];
    
    [TTRibbonsAnimation show];
    
    NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
    if ([robotId integerValue] > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [GetCore(RoomQueueCoreV2) removeChatroomQueueWithPosition:@"0" uid:robotId.userIDValue success:^(BOOL success) {
                
            } failure:^(NSString *message) {
                
            }];
            [GetCore(ImRoomCoreV2) kickUser:robotId.userIDValue];
        });
    }
    
    self.victoryImageView.image = [UIImage imageNamed:@"room_cp_game_victory"];
    //  游戏结束，并且我赢了的回调
    TTCPGameCustomModel *customModel = [TTCPGameCustomModel modelWithJSON:relustDict];
    
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = self.datasourceArray[i];
        if ([model.gameId isEqualToString:customModel.gameResultInfo.gameId]) {
            _gameNameLabel.text = [NSString stringWithFormat:@"- %@ -",model.gameName];
            [_gameNameLabel sizeToFit];
            _gameNameLabel.centerX = KScreenWidth / 2;
            
            _avatorImageView.top = _gameNameLabel.bottom + 9;
        }
    }
    NSString *avatorString = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.winners safeObjectAtIndex:0][@"uid"] userIDValue]] avatar];
    
    [_avaImageView qn_setImageImageWithUrl:avatorString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    
    [self gameVictoryAction];
}

-(void)gameVictoryAction {
    [self GameOverAndOnePartyWonGameUI];
}

- (TTGameSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[TTGameSelectView alloc] init];
        _selectView.size = CGSizeMake(self.finalyWidth, self.finalyHeight);
        _selectView.top = 0;
        _selectView.centerX = KScreenWidth / 2;
        _selectView.hidden = YES;
    }
    return _selectView;
}

-(UIImageView *)victoryImageView {
    if (!_victoryImageView) {
        self.victoryImageView = [[UIImageView alloc] init];
        _victoryImageView.size = CGSizeMake(204, 116);
        _victoryImageView.image = [UIImage imageNamed:@"room_cp_game_victory"];
        _victoryImageView.centerX = KScreenWidth / 2;
        _victoryImageView.bottom = 20;
        _victoryImageView.hidden = YES;
    }
    return _victoryImageView;
}

-(UILabel *)gameNameLabel {
    if (!_gameNameLabel) {
        self.gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.font = [UIFont systemFontOfSize:15];
        _gameNameLabel.textColor = UIColor.whiteColor;
        _gameNameLabel.top = _victoryImageView.bottom;
        _gameNameLabel.hidden = YES;
    }
    return _gameNameLabel;
}

- (YYLabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[YYLabel alloc] init];
        _nickNameLabel.hidden = YES;
        _nickNameLabel.height = 14;
    }
    return _nickNameLabel;
}

-(UIButton *)attentionBtn {
    if (!_attentionBtn) {
        self.attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        _attentionBtn.backgroundColor = [XCTheme getTTMainColor];
        [_attentionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _attentionBtn.size = CGSizeMake(65, 24);
        _attentionBtn.layer.cornerRadius = _attentionBtn.height / 2;
        _attentionBtn.layer.masksToBounds = YES;
        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _attentionBtn.hidden = YES;
        _attentionBtn.centerX = KScreenWidth / 2;
        [_attentionBtn addTarget:self action:@selector(attenBtnActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

-(UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        self.avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.image = [UIImage imageNamed:@"room_cp_game_victory_head"];
        _avatorImageView.size = CGSizeMake(kScale(81), kScale(87));
        _avatorImageView.centerX = KScreenWidth / 2;
        _avatorImageView.hidden = YES;
    }
    return _avatorImageView;
}

-(UIImageView *)avaImageView {
    if (!_avaImageView) {
        self.avaImageView = [[UIImageView alloc] init];
        _avaImageView.size = CGSizeMake(kScale(64), kScale(64));
        _avaImageView.right = _avatorImageView.width - 3;
        _avaImageView.bottom = _avatorImageView.height - 2;
        _avaImageView.layer.cornerRadius = _avaImageView.width / 2;
        _avaImageView.layer.masksToBounds = YES;
    }
    return _avaImageView;
}

-(UIImageView *)failImageView {
    if (!_failImageView) {
        self.failImageView = [[UIImageView alloc] init];
        _failImageView.size = CGSizeMake(kScale(69), kScale(69));
        _failImageView.centerX = KScreenWidth / 2;
        _failImageView.layer.borderWidth = 3;
        _failImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _failImageView.layer.cornerRadius = _failImageView.width / 2;
        _failImageView.layer.masksToBounds = YES;
        _failImageView.hidden = YES;
    }
    return _failImageView;
}

-(TTCustomAvatorImageView *)leftImageView {
    if (!_leftImageView) {
        self.leftImageView = [[TTCustomAvatorImageView alloc] init];
        _leftImageView.size = CGSizeMake(kScale(69), kScale(69));
        _leftImageView.right = KScreenWidth / 2 + 12;
        _leftImageView.layer.borderWidth = 3;
        _leftImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _leftImageView.layer.cornerRadius = _leftImageView.width / 2;
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.hidden = YES;
    }
    return _leftImageView;
}

-(TTCustomAvatorImageView *)rightImageView {
    if (!_rightImageView) {
        self.rightImageView = [[TTCustomAvatorImageView alloc] init];
        _rightImageView.size = CGSizeMake(kScale(69), kScale(69));
        _rightImageView.left = KScreenWidth / 2 - 12;
        _rightImageView.layer.borderWidth = 3;
        _rightImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _rightImageView.layer.cornerRadius = _rightImageView.width / 2;
        _rightImageView.layer.masksToBounds = YES;
        _rightImageView.hidden = YES;
    }
    return _rightImageView;
}

-(UIImageView *)leftAudienceImageView {
    if (!_leftAudienceImageView) {
        self.leftAudienceImageView = [[UIImageView alloc] init];
        _leftAudienceImageView.size = CGSizeMake(kScale(69), kScale(69));
        _leftAudienceImageView.right = KScreenWidth / 2 - 25;
        _leftAudienceImageView.layer.borderWidth = 3;
        _leftAudienceImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _leftAudienceImageView.layer.cornerRadius = _leftAudienceImageView.width / 2;
        _leftAudienceImageView.layer.masksToBounds = YES;
        _leftAudienceImageView.hidden = YES;
    }
    return _leftAudienceImageView;
}

-(UIImageView *)rightAudienceImageView {
    if (!_rightAudienceImageView) {
        self.rightAudienceImageView = [[UIImageView alloc] init];
        _rightAudienceImageView.size = CGSizeMake(kScale(69), kScale(69));
        _rightAudienceImageView.left = KScreenWidth / 2 + 25;
        _rightAudienceImageView.layer.borderWidth = 3;
        _rightAudienceImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _rightAudienceImageView.layer.cornerRadius = _rightAudienceImageView.width / 2;
        _rightAudienceImageView.layer.masksToBounds = YES;
        _rightAudienceImageView.hidden = YES;
    }
    return _rightAudienceImageView;
}

-(YYLabel *)leftAudienceLabel{
    if (!_leftAudienceLabel) {
        _leftAudienceLabel = [[YYLabel alloc] init];
        _leftAudienceLabel.hidden = YES;
        _leftAudienceLabel.height = 14;
    }
    return _leftAudienceLabel;
}

-(YYLabel *)rightAudienceLabel{
    if (!_rightAudienceLabel) {
        _rightAudienceLabel = [[YYLabel alloc] init];
        _rightAudienceLabel.hidden = YES;
        _rightAudienceLabel.height = 14;
    }
    return _rightAudienceLabel;
}

-(UIButton *)leftAudienceBtn{
    if (!_leftAudienceBtn) {
        self.leftAudienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftAudienceBtn setTitle:@"关注" forState:UIControlStateNormal];
        _leftAudienceBtn.backgroundColor = [XCTheme getTTMainColor];
        [_leftAudienceBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _leftAudienceBtn.size = CGSizeMake(kScale(65), kScale(24));
        _leftAudienceBtn.layer.cornerRadius = _leftAudienceBtn.height / 2;
        _leftAudienceBtn.layer.masksToBounds = YES;
        _leftAudienceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _leftAudienceBtn.hidden = YES;
        [_leftAudienceBtn addTarget:self action:@selector(leftGuanZhuAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftAudienceBtn;
}

-(UIButton *)rightAudienceBtn{
    if (!_rightAudienceBtn) {
        self.rightAudienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightAudienceBtn setTitle:@"关注" forState:UIControlStateNormal];
        _rightAudienceBtn.backgroundColor = [XCTheme getTTMainColor];
        [_rightAudienceBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _rightAudienceBtn.size = CGSizeMake(kScale(65), kScale(24));
        _rightAudienceBtn.layer.cornerRadius = _rightAudienceBtn.height / 2;
        _rightAudienceBtn.layer.masksToBounds = YES;
        _rightAudienceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _rightAudienceBtn.hidden = YES;
        _rightAudienceBtn.centerX = KScreenWidth / 2;
        [_rightAudienceBtn addTarget:self action:@selector(rightGuanZhuAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightAudienceBtn;
}

- (void)leftGuanZhuAction:(UIButton *)sender{
    if (!self.leftAttention) {
        [[BaiduMobStat defaultStat] logEvent:@"roomcp_gameover_follow_click" eventLabel:@"关注"];
        NSString * mine = [GetCore(AuthCore) getUid];
        [XCHUDTool showSuccessWithMessage:@"关注成功"];
        [GetCore(PraiseCore) praise:mine.userIDValue bePraisedUid:self.leftAttenID];
        sender.hidden = YES;
    }
}

- (void)rightGuanZhuAction:(UIButton *)sender{
    if (!self.rightAttention) {
        [[BaiduMobStat defaultStat] logEvent:@"roomcp_gameover_follow_click" eventLabel:@"关注"];
        NSString * mine = [GetCore(AuthCore) getUid];

        [XCHUDTool showSuccessWithMessage:@"关注成功"];
        [GetCore(PraiseCore) praise:mine.userIDValue bePraisedUid:self.rightAttenID];

        sender.hidden = YES;
    }
}

-(UIButton *)watchingBtn{
    if (!_watchingBtn) {
        self.watchingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _watchingBtn.size = CGSizeMake(kScale(120), kScale(34));
        [_watchingBtn setTitle:@"进入观战" forState:UIControlStateNormal];
        [_watchingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        _watchingBtn.top = 34 + self.finalyHeight + 8;
        _watchingBtn.centerX = KScreenWidth / 2;
        _watchingBtn.hidden = YES;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _watchingBtn.bounds;
        gradient.colors = @[(id)UIColorFromRGB(0x05C7C7).CGColor,(id)UIColorFromRGB(0x57EDC2).CGColor];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        [_watchingBtn.layer addSublayer:gradient];
        
        _watchingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _watchingBtn.layer.cornerRadius = 17;
        _watchingBtn.layer.masksToBounds = YES;
        [_watchingBtn addTarget:self action:@selector(watchGameAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _watchingBtn;
}

-(UIButton *)changeGameBtn{
    if (!_changeGameBtn) {
        self.changeGameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeGameBtn.size = CGSizeMake(kScale(120), kScale(34));
        [_changeGameBtn setTitle:@"换一个" forState:UIControlStateNormal];
        [_changeGameBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _changeGameBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _changeGameBtn.top = 34 + self.finalyHeight + 8;
        _changeGameBtn.right = KScreenWidth / 2 - 12;
        _changeGameBtn.layer.borderWidth = 1;
        _changeGameBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        _changeGameBtn.layer.masksToBounds = YES;
        _changeGameBtn.layer.cornerRadius = 17;
        _changeGameBtn.hidden = YES;
        [_changeGameBtn addTarget:self action:@selector(changeGameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeGameBtn;
}

- (UILabel *)watchingLabel{
    if (!_watchingLabel) {
        _watchingLabel = [[UILabel alloc] init];
        _watchingLabel.text = @"游戏选择中";
        _watchingLabel.textColor = UIColorFromRGB(0xffffff);
        _watchingLabel.font = [UIFont systemFontOfSize:15];
        _watchingLabel.top = 34 + self.finalyHeight + 20;
        [_watchingLabel sizeToFit];
        _watchingLabel.hidden = YES;
        _watchingLabel.centerX = KScreenWidth / 2;
    }
    return _watchingLabel;
}

-(void)changeGameBtnAction:(UIButton *)sender{
    
    [[BaiduMobStat defaultStat]logEvent:@"roomcp_gameover_cha_click" eventLabel:@"换个游戏"];
    [self refuseAction];
    
    //  游戏结束 其中一方点击了 换个游戏 要回到选择游戏页面  游戏状态变为选择中
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(ImRoomCoreV2).currentRoomInfo.uid WithGameStatus:2 GameId:@"" gameName:@"" StartUid:@""] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];;
    
    TTCPGameCustomInfo *gameInfo = [TTCPGameCustomInfo modelWithJSON:GetCore(ImRoomCoreV2).currentRoomInfo.roomGame];
    
    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
    cpAtt.gameInfo = gameInfo;
    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_CPGAME;
    attachement.second = Custom_Noti_Sub_CPGAME_Cancel_Prepare;
    attachement.data = [cpAtt model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}

-(UIButton *)againGameBtn{
    if (!_againGameBtn) {
        self.againGameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _againGameBtn.size = CGSizeMake(kScale(120), 34);
        [_againGameBtn setTitle:@"再来一局" forState:UIControlStateNormal];
        [_againGameBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _againGameBtn.top = 34 + self.finalyHeight + 8;
        _againGameBtn.left = KScreenWidth / 2 + 12;
        _againGameBtn.hidden = YES;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _againGameBtn.bounds;
        gradient.colors = @[(id)UIColorFromRGB(0x05C7C7).CGColor,(id)UIColorFromRGB(0x57EDC2).CGColor];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        [_againGameBtn.layer addSublayer:gradient];
        
        _againGameBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _againGameBtn.layer.cornerRadius = 17;
        _againGameBtn.layer.masksToBounds = YES;
        [_againGameBtn addTarget:self action:@selector(againGameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _againGameBtn;
}

-(void)againGameBtnAction:(UIButton *)sender{
    [[BaiduMobStat defaultStat]logEvent:@"roomcp_gameover_anr_click" eventLabel:@"再来一局"];
    // 游戏结束，其中一个人点击了再来一局  发送云信通知 游戏状态变为 准备中

    [self HaveChoiceGameMyOwnUI];
    
    CPGameListModel *model = self.datasourceArray[self.selectIndex];
    
    [[GetCore(CPGameCore) requestGameRoomid:GetCore(ImRoomCoreV2).currentRoomInfo.uid WithGameStatus:3 GameId:model.gameId gameName:model.gameName StartUid:GetCore(AuthCore).getUid] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    }];;
    
    TTCPGameCustomInfo *gameInfo = [[TTCPGameCustomInfo alloc] init];
    gameInfo = [TTCPGameCustomInfo modelWithJSON:[model model2dictionary]];
    if (!gameInfo) {
        gameInfo = [TTCPGameCustomInfo modelWithJSON:GetCore(ImRoomCoreV2).currentRoomInfo.roomGame];
    }
    
    self.selectView.gameModel = model;
    
    TTCPGameCustomModel *cpAtt = [[TTCPGameCustomModel alloc] init];
    cpAtt.gameInfo = gameInfo;
    cpAtt.nick = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick;
    
    Attachment *attachement = [[Attachment alloc]init];
    attachement.first = Custom_Noti_Header_CPGAME;
    attachement.second = Custom_Noti_Sub_CPGAME_Select;
    attachement.data = [cpAtt model2dictionary];
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attachement sessionId:[NSString stringWithFormat:@"%ld",(long)GetCore(ImRoomCoreV2).currentRoomInfo.roomId] type:NIMSessionTypeChatroom];
}


#pragma mark ---- 游戏结束 失败一方的UI ----
-(void)gamefailerAction:(TTCPGameCustomModel *)customModel{
    
    NSURL *faileUrl = [[NSBundle mainBundle] URLForResource:@"lose" withExtension:@"mp3"];
    self.musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:faileUrl error:nil];
    [self.musicPlayer play];
    
    NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
    if ([robotId integerValue] > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [GetCore(RoomQueueCoreV2) removeChatroomQueueWithPosition:@"0" uid:robotId.userIDValue success:^(BOOL success) {
                
            } failure:^(NSString *message) {
                
            }];
            
            [GetCore(ImRoomCoreV2) kickUser:robotId.userIDValue];
            
            //            [GetCore(ImRoomCoreV2).micQueue removeObjectForKey:@"0"];
            //                for (int i = 0; i < [[GetCore(ImRoomCoreV2).micQueue allKeys] count]; i++) {
            //                    ChatRoomMicSequence *sequence = [GetCore(ImRoomCoreV2).micQueue objectForKey:[NSString stringWithFormat:@"%d",i - 1]];
            //                    if (sequence.userInfo.uid == robotId.userIDValue) {
            //
            //
            //                    }
            //                }
        });
    }
    
    
    [self GameOverAndOnePartyFailureGameUI];
    
    self.victoryImageView.image = [UIImage imageNamed:@"room_cp_game_defeated"];
    
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = self.datasourceArray[i];
        if ([model.gameId isEqualToString:customModel.gameResultInfo.gameId]) {
            _gameNameLabel.text = [NSString stringWithFormat:@"- %@ -",model.gameName];
            [_gameNameLabel sizeToFit];
            _gameNameLabel.centerX = KScreenWidth / 2;
            
            _failImageView.top = _gameNameLabel.bottom + 30;
            
            NSString *avatorString = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.failers safeObjectAtIndex:0][@"uid"] userIDValue]] avatar];
            
            [_failImageView qn_setImageImageWithUrl:avatorString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
        }
    }
}

#pragma mark ---- 游戏结束 不可思议的结局。平局 ----
-(void)gameOverAndNobodyWin:(NSDictionary *)relustDict{
    
    [self GameOverAndDrawGameUI];
    
    self.victoryImageView.image = [UIImage imageNamed:@"room_cp_game_draw"];
    
    TTCPGameCustomModel *customModel = [TTCPGameCustomModel modelWithJSON:relustDict];
    
    NSString *robotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Robot"];
    if ([robotId integerValue] > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GetCore(RoomQueueCoreV2) removeChatroomQueueWithPosition:@"0" uid:robotId.userIDValue success:^(BOOL success) {
                
            } failure:^(NSString *message) {
                
            }];
            [GetCore(ImRoomCoreV2) kickUser:robotId.userIDValue];
        });
    }
    for (int i = 0; i < self.datasourceArray.count; i++) {
        CPGameListModel *model = self.datasourceArray[i];
        if ([model.gameId isEqualToString:customModel.gameResultInfo.gameId]) {
            _gameNameLabel.text = [NSString stringWithFormat:@"- %@ -",model.gameName];
            [_gameNameLabel sizeToFit];
            _gameNameLabel.centerX = KScreenWidth / 2;
            
            _leftImageView.top = _gameNameLabel.bottom + 30;
            _rightImageView.top = _leftImageView.top;
        }
    }
    
    NSString *leftAvatorString = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.users safeObjectAtIndex:0][@"uid"] userIDValue]] avatar];
    
    NSString *rightAvatorString = [[GetCore(UserCore) getUserInfoInDB:[[customModel.gameResultInfo.users safeObjectAtIndex:1][@"uid"] userIDValue]] avatar];
    
    [_leftImageView qn_setImageImageWithUrl:leftAvatorString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    _leftImageView.maskImageView.hidden = YES;
    
    [_rightImageView qn_setImageImageWithUrl:rightAvatorString placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    _rightImageView.maskImageView.hidden = YES;
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
