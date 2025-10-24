//
//  TTNewbieGuideView.h
//  AFNetworking
//
//  Created by apple on 2019/5/21.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TTGuideViewPage_Home = 1, // 主页
    TTGuideViewPage_Message = 2, // 消息页
    TTGuideViewPage_Person = 3, // 个人页
    TTGuideViewPage_Room = 4, // 房间页
    TTGuideViewPage_Gift = 5, // 房间里面的礼物界面
    TTGuideViewPage_Voice = 6, // 声音匹配
    TTGuideViewPage_GameHome = 7, // 游戏主页
    TTGuideViewPage_WorldSquare = 8, // 小世界-世界广场
    TTGuideViewPage_WorldJoin = 9, // 小世界-客态页加入
    TTGuideViewPage_WorldMessage = 10, // 小世界-客态页消息
} TTGuideViewPageType;


typedef void(^retrunCurrentType)(NSInteger index);
typedef void(^didFinishDismissingBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TTNewbieGuideView : UIView

/**
 新手引导页
 @param frame 新手引导页大小
 @param rect 需要抠图的大小 如果是需要抠多个图，传下面的dataArray数据即可，这个值为CGRectZero
 @param space 是否需要抠图，全屏图片传NO
 @param corner 抠图的圆角大小
 @param pageIndex 引导页属于哪个页面
 */
- (instancetype)initWithFrame:(CGRect)frame withArcWithFrame:(CGRect )rect withSpace:(BOOL)space withCorner:(NSInteger )corner withPage:(TTGuideViewPageType )pageIndex;

/**
 需要多个抠图时，传 CGRect数组 @[@(CGRect)]
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 当前页面有多个引导页时，block返回
 在block回调里面 去调用下面的两个方法
 */
@property (nonatomic, copy) retrunCurrentType currentType;

/**
 当引导页彻底消失的时候，block 回调
 一般用于在引导结束后处理的某些逻辑(房间内新手礼物)
 */
@property (nonatomic, copy) didFinishDismissingBlock dismissingBlock;
/**
 抠图的方法

 @param rect 当前页面有多个新手引导页，点击下一步时，需要新的rect位置
 @param corner 圆角
 */
- (void)addArcWithFrame:(CGRect )rect withCorner:(NSInteger )corner;

/**
 @param pageIndex 点击下一步时，要清除上一个layer的subLayer
 调用应该是 [self addArcWithFrame:rect withCorner:corner]
          [self initViewWithPageName:pageIndex]
 */
- (void)initViewWithPageName:(TTGuideViewPageType )pageIndex;

@end

NS_ASSUME_NONNULL_END
