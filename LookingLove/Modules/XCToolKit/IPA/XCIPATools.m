//
//  XCIPA.m
//  XChatFramework
//
//  Created by Mac on 2018/3/6.
//  Copyright © 2018年 chenran. All rights reserved.
//

#ifdef DEBUG
#define checkURL @"https://sandbox.itunes.apple.com/verifyReceipt"
#else
#define checkURL @"https://buy.itunes.apple.com/verifyReceipt"
#endif

#import "XCIPATools.h"

@interface XCIPATools()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

//商品字典
@property(nonatomic,strong)NSMutableDictionary *productDict;
//价格字典
@property(nonatomic,strong)NSDictionary *productPrice;


@end

@implementation XCIPATools

static XCIPATools *storeTool;

#pragma mark - life cycle
+(XCIPATools *)defaultTool{
    if(!storeTool){
        storeTool = [XCIPATools new];
        [storeTool setup];
    }
    return storeTool;
}

-(void)setup{
    
    self.CheckAfterPay = YES;
    
    // 设置购买队列的监听器
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}

#pragma mark - SKProductsRequestDelegate
/**
 *  获取询问结果，成功采取操作把商品加入可售商品字典里
 *
 *  @param request  请求内容
 *  @param response 返回的结果
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (self.productDict == nil) {
        self.productDict = [NSMutableDictionary dictionaryWithCapacity:response.products.count];
    }
    
    NSMutableArray *productArray = [NSMutableArray array];
    
    for (SKProduct *product in response.products) {
        //NSLog(@"%@", product.productIdentifier);
        
        // 填充商品字典
        [self.productDict setObject:product forKey:product.productIdentifier];
        
        [productArray addObject:product];
    }
    //通知代理
    if ([self.delegate respondsToSelector:@selector(IAPToolGotProducts:)]) {
        [self.delegate IAPToolGotProducts:productArray];
    }
}

#pragma mark - SKPaymentTransactionObserver
/**
 *  监测购买队列的变化
 *
 *  @param queue        队列
 *  @param transactions 交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    // 处理结果
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"队列状态变化 %@", transaction);
        // 如果小票状态是购买完成
        if (SKPaymentTransactionStatePurchased == transaction.transactionState) {
            NSLog(@"购买完成,向自己的服务器验证 ---- %@", transaction.payment.applicationUsername);
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
            if(self.CheckAfterPay){
                //购买成功跟服务器验证
                if ([self.delegate respondsToSelector:@selector(IAPToolBeginCheckingdWithProductID:receipt:)]) {
                    [self.delegate IAPToolBeginCheckingdWithProductID:transaction.payment.productIdentifier receipt:data];
                }
                // 验证购买凭据,不要管结果
//                [self verifyPruchaseWithID:transaction.payment.productIdentifier];
            }else{
                 if ([self.delegate respondsToSelector:@selector(IAPToolBoughtProductSuccessedWithProductID:andInfo:)]) {
                       [self.delegate IAPToolBoughtProductSuccessedWithProductID:transaction.payment.productIdentifier andInfo:nil];
                 }
            }
            
            
        } else if (SKPaymentTransactionStateRestored == transaction.transactionState) {
            NSLog(@"恢复成功 :%@", transaction.payment.productIdentifier);
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            if ([self.delegate respondsToSelector:@selector(IAPToolRestoredProductID:)]) {
                [self.delegate IAPToolRestoredProductID:transaction.payment.productIdentifier];
            }
        } else if (SKPaymentTransactionStateFailed == transaction.transactionState){
            
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            NSLog(@"交易失败");
            if ([self.delegate respondsToSelector:@selector(IAPToolCanceldWithProductID:)]) {
                [self.delegate IAPToolCanceldWithProductID:transaction.payment.productIdentifier];
            }
            
        }else if(SKPaymentTransactionStatePurchasing == transaction.transactionState){
            NSLog(@"正在购买");
        }else{
            NSLog(@"state:%ld",(long)transaction.transactionState);
            NSLog(@"已经购买");
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}

#pragma mark - puble method
//询问苹果的服务器能够销售哪些商品
- (void)requestProductsWithProductArray:(NSArray *)products
{
    NSLog(@"开始请求可销售商品");
    
    // 能够销售的商品
    NSSet *set = [[NSSet alloc] initWithArray:products];
    
    // "异步"询问苹果能否销售
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    
    request.delegate = self;
    
    // 启动请求
    [request start];
}
/**
 *  用户决定购买商品
 *
 *  @param productID 商品ID
 */
- (void)buyProduct:(NSString *)productID{
    
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        for (SKPaymentTransaction* transaction in transactions) {
            if (transaction.transactionState != SKPaymentTransactionStatePurchasing) {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

            }
        }
    }
    
    
    SKProduct *product = self.productDict[productID];
    // 要购买产品(店员给用户开了个小票)添加自定义的参数
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
//    payment.applicationUsername = LH.userInfor.userId;
    // 准备购买
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//  恢复商品 
- (void)restorePurchase
{
    // 恢复已经完成的所有交易.（仅限永久有效商品）
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}



#pragma mark - private method
/**
 *  验证购买凭据
 *
 *  @param ProductID 商品ID
 */
- (void)verifyPruchaseWithID:(NSString *)ProductID
{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    // 发送网络POST请求，对购买凭据进行验证
    NSURL *url = [NSURL URLWithString:checkURL];
    NSLog(@"checkURL:%@",checkURL);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    request.HTTPMethod = @"POST";

    
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // 官方验证结果为空
    if (result == nil) {
        NSLog(@"验证失败");
//        if ([self.delegate respondsToSelector:@selector(IAPToolCheckFailedWithProductID:andInfo:)]) {
//            [self.delegate IAPToolCheckFailedWithProductID:ProductID andInfo:result];
//        }
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    if (dict != nil) {
        // 验证成功
//        if ([self.delegate respondsToSelector:@selector(IAPToolBoughtProductSuccessedWithProductID:andInfo:)]) {
//            [self.delegate IAPToolBoughtProductSuccessedWithProductID:ProductID andInfo:dict];
//        }
    }else{
        //验证失败
//        if ([self.delegate respondsToSelector:@selector(IAPToolCheckFailedWithProductID:andInfo:)]) {
//            [self.delegate IAPToolCheckFailedWithProductID:ProductID andInfo:result];
//        }
    }
}

@end
