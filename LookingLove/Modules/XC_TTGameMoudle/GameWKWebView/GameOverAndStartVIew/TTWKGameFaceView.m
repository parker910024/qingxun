//
//  TTWKGameFaceView.m
//  AFNetworking
//
//  Created by new on 2019/4/18.
//

#import "TTWKGameFaceView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "CPGameCore.h"
#import "AuthCore.h"
#import "NSArray+Safe.h"
#import "UIButton+EnlargeTouchArea.h"

#import "UIView+NTES.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "TTGameInformationModel.h"
#import <NIMSDK/NIMSDK.h>

@interface TTWKGameFaceView ()

@property (nonatomic, strong) NSMutableArray *datasourceArray;

@end

@implementation TTWKGameFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        
        [self requestData];
    }
    return self;
}

- (void)initView {
    if (self.datasourceArray.count > 0) {
        for (int i = self.datasourceArray.count - 1; i >= 0; i--) {
            UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            faceButton.size = CGSizeMake(44, 44);
            faceButton.right = self.width - (faceButton.width + 10) * (self.datasourceArray.count - 1 - i);
            faceButton.top = 0;
            faceButton.tag = 100 + i;
            faceButton.backgroundColor = UIColorRGBAlpha(0x333333, 0.3);
            faceButton.layer.cornerRadius = 44 / 2;
            [faceButton sd_setImageWithURL:[NSURL URLWithString:self.datasourceArray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square]];
            if (i == 0) {
                faceButton.imageFrame = [NSValue valueWithCGRect:CGRectMake(2.5, 2, 40, 40)];
            } else {
                faceButton.imageFrame = [NSValue valueWithCGRect:CGRectMake(2, 2, 40, 40)];
            }
            [faceButton addTarget:self action:@selector(sendFaceAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:faceButton];
        }
    }
}

- (void)sendFaceAction:(UIButton *)sender {
    NSString *faceString = [self.datasourceArray safeObjectAtIndex:(sender.tag - 100)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendFaceWithImageString:WithObj:)]) {
        [self.delegate sendFaceWithImageString:faceString WithObj:self];
    }
    
    switch (sender.tag - 100) {
        case 0:{
            [[BaiduMobStat defaultStat] logEvent:@"h5_gamepage_expression" eventLabel:@"发送表情1"];
#ifdef DEBUG
            NSLog(@"h5_gamepage_expression");
#else
            
#endif
            break;}
        case 1:{
            [[BaiduMobStat defaultStat] logEvent:@"h5_gamepage_expression" eventLabel:@"发送表情2"];
#ifdef DEBUG
            NSLog(@"h5_gamepage_expression");
#else
            
#endif
            break;}
        case 2:{
            [[BaiduMobStat defaultStat] logEvent:@"h5_gamepage_expression" eventLabel:@"发送表情3"];
#ifdef DEBUG
            NSLog(@"h5_gamepage_expression");
#else
            
#endif
            break;}
            
        default:
            break;
    }
    
    
    
    UserID otherUid;
    if (self.dataModel.uidLeft == GetCore(AuthCore).getUid.userIDValue) {
        otherUid = self.dataModel.uidRight;
    }else{
        otherUid = self.dataModel.uidLeft;
    }
    NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%lld",otherUid] type:NIMSessionTypeP2P];
    
    NSDictionary *dict = @{@"faceUrl":faceString};
    
    NSString *imageString = [dict yy_modelToJSONString];
    
    NIMCustomSystemNotification *Notification = [[NIMCustomSystemNotification alloc] initWithContent:imageString];
    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:Notification toSession:session completion:nil];
}

- (void)setDataModel:(TTGameInformationModel *)dataModel {
    _dataModel = dataModel;
    
}


- (void)requestData {
    [[GetCore(CPGameCore) requestGetGameFace] subscribeNext:^(id x) {
        [self.datasourceArray addObjectsFromArray:x];
        [self initView];
    }];
}

- (NSMutableArray *)datasourceArray {
    if (!_datasourceArray) {
        _datasourceArray = [NSMutableArray array];
    }
    return _datasourceArray;
}

@end
