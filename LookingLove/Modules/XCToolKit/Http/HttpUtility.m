

#import "HttpUtility.h"

@implementation HttpUtility

+ (NSString *)urlEncode:(NSString *)urlString
{
    if (!urlString)
        return @"";
    if (![urlString isKindOfClass:[NSString class]]) {
        return @"";
    }
    CFStringRef originalString = (__bridge  CFStringRef)urlString;
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        originalString,
                                                                        NULL,
                                                                        CFSTR( ":/?#[]@!$&'()*+,;=" ),
                                                                        kCFStringEncodingUTF8);
    NSString *encodedUrl = (__bridge_transfer NSString *)encodedString;
    return encodedUrl;
}

+ (NSString *)urlDecode:(NSString *)urlString
{
    NSString *decodeString = [urlString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [decodeString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
