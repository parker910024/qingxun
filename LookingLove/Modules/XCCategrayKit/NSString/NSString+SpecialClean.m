//
//  NSString+SpecialClean.m
//  YYMobileFramework
//
//  Created by JianchengShi on 2015/1/15.
//  Copyright (c) 2015年 YY Inc. All rights reserved.
//

#import "NSString+SpecialClean.h"
//#import "YYUtility.h"

#define DealSpecialString 1

@implementation NSString (SpecialClean)

- (NSString *)cleanLeftSpace {
    return [self stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)cleanRightSpace {
    return [self stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)cleanSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)cleanSpaceAndWrap {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer range:NSMakeRange(0, length)];
    
    for (NSInteger i = 0; i < length; i++) {
        if (![characterSet characterIsMember:charBuffer[i]]) {
            location = i;
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer range:NSMakeRange(0, length)];
    
    NSUInteger subLength = 0;
    for (NSInteger i = length; i > 0; i--) {
        if (![characterSet characterIsMember:charBuffer[i - 1]]) {
            subLength = i;
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(0, subLength)];
}

- (NSString *)cleanSpecialTextByReplacingSpecialCharacter:(NSString *)string
{
    return string?:@"";
//    if (!string) {
//        return string;
//    }
//
//#if DealSpecialString
//
////    if([[YYUtility systemVersion] floatValue] >= 8.0) {
////        return string;
////    }
//
//    NSError *error = nil;
//
//    NSString * regexString = regexFilterString();
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
//    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"□"];
//    return modifiedString ? modifiedString : @"";
//#else
//
//    return string;
//#endif
    
}

static NSString* emojiRegex()
{
    static id instance;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        //        instance = @"😄😃😀😊☺️😉😍😘😚😗😙😜😝😛😳😁😔😌😒😞😣😢😂😭😪😥😰😅😓😩😫😨😱😠😡😤😖😆😋😷😎😴😵😲😟😦😧😈👿😮😬😐😕😯😶😇😏😑👲👳👮👷💂👶👦👧👨👩👴👵👱👼👸😺😸😻😽😼🙀😿😹😾👹👺🙈🙉🙊💀👽💩🔥✨🌟💫💥💢💦💧💤💨👂👀👃👅👄👍👎👌👊✊✌️👋✋👐👆👇👉👈🙌🙏☝️👏💪🚶🏃💃👫👪👬👭💏💑👯🙆🙅💁🙋💆💇💅👰🙎🙍🙇🎩👑👒👟👞👡👠👢👕👔👚👗🎽👖👘👙💼👜👝👛👓🎀🌂💄💛💙💜💚❤️💔💗💓💕💖💞💘💌💋💍💎👤👥💬👣💭🐶🐺🐱🐭🐹🐰🐸🐯🐨🐻🐷🐽🐮🐗🐵🐒🐴🐑🐘🐼🐧🐦🐤🐥🐣🐔🐍🐢🐛🐝🐜🐞🐌🐙🐚🐠🐟🐬🐳🐋🐄🐏🐀🐃🐅🐇🐉🐎🐐🐓🐕🐖🐁🐂🐲🐡🐊🐫🐪🐆🐈🐩🐾💐🌸🌷🍀🌹🌻🌺🍁🍃🍂🌿🌾🍄🌵🌴🌲🌳🌰🌱🌼🌐🌞🌝🌚🌑🌒🌓🌔🌕🌖🌗🌘🌜🌛🌙🌍🌎🌏🌋🌌🌠⭐️☀️⛅️☁️⚡️☔️❄️⛄️🌀🌁🌈🌊🎍💝🎎🎒🎓🎏🎆🎇🎐🎑🎃👻🎅🎄🎁🎋🎉🎊🎈🎌🔮🎥📷📹📼💿📀💽💾💻📱☎️📞📟📠📡📺📻🔊🔉🔈🔇🔔🔕📢📣⏳⌛️⏰⌚️🔓🔒🔏🔐🔑🔎💡🔦🔆🔅🔌🔋🔍🛁🛀🚿🚽🔧🔩🔨🚪🚬💣🔫🔪💊💉💰💴💵💷💶💳💸📲📧📥📤✉️📩📨📯📫📪📬📭📮📦📝📄📃📑📊📈📉📜📋📅📆📇📁📂✂️📌📎✒️✏️📏📐📕📗📘📙📓📔📒📚📖🔖📛🔬🔭📰🎨🎬🎤🎧🎼🎵🎶🎹🎻🎺🎷🎸👾🎮🃏🎴🀄️🎲🎯🏈🏀⚽️⚾️🎾🎱🏉🎳⛳️🚵🚴🏁🏇🏆🎿🏂🏊🏄🎣☕️🍵🍶🍼🍺🍻🍸🍹🍷🍴🍕🍔🍟🍗🍖🍝🍛🍤🍱🍣🍥🍙🍘🍚🍜🍲🍢🍡🍳🍞🍩🍮🍦🍨🍧🎂🍰🍪🍫🍬🍭🍯🍎🍏🍊🍋🍒🍇🍉🍓🍑🍈🍌🍐🍍🍠🍆🍅🌽🏠🏡🏫🏢🏣🏥🏦🏪🏩🏨💒⛪️🏬🏤🌇🌆🏯🏰⛺️🏭🗼🗾🗻🌄🌅🌃🗽🌉🎠🎡⛲️🎢🚢⛵️🚤🚣⚓️🚀✈️💺🚁🚂🚊🚉🚞🚆🚄🚅🚈🚇🚝🚋🚃🚎🚌🚍🚙🚘🚗🚕🚖🚛🚚🚨🚓🚔🚒🚑🚐🚲🚡🚟🚠🚜💈🚏🎫🚦🚥⚠️🚧🔰⛽️🏮🎰♨️🗿🎪🎭📍🚩🇯🇵🇰🇷🇩🇪🇨🇳🇺🇸🇫🇷🇪🇸🇮🇹🇷🇺🇬🇧1⃣2⃣3⃣4⃣5⃣6⃣7⃣8⃣9⃣0⃣🔟🔢#⃣🔣⬆️⬇️⬅️➡️🔠🔡🔤↗️↖️↘️↙️↔️↕️🔄◀️▶️🔼🔽↩️↪️ℹ️⏪⏩⏫⏬⤵️⤴️🆗🔀🔁🔂🆕🆙🆒🆓🆖📶🎦🈁🈯️🈳🈵🈴🈲🉐🈹🈺🈶🈚️🚻🚹🚺🚼🚾🚰🚮🅿️♿️🚭🈷🈸🈂Ⓜ️🛂🛄🛅🛃🉑㊙️㊗️🆑🆘🆔🚫🔞📵🚯🚱🚳🚷🚸⛔️✳️❇️❎✅✴️💟🆚📳📴🅰🅱🆎🅾💠➿♻️♈️♉️♊️♋️♌️♍️♎️♏️♐️♑️♒️♓️⛎🔯🏧💹💲💱©®™❌‼️⁉️❗️❓❕❔⭕️🔝🔚🔙🔛🔜🔃🕛🕧🕐🕜🕑🕝🕒🕞🕓🕟🕔🕠🕕🕖🕗🕘🕙🕚🕡🕢🕣🕤🕥🕦✖️➕➖➗♠️♥️♣️♦️💮💯✔️☑️🔘🔗➰〰〽️🔱◼️◻️◾️◽️▪️▫️🔺🔲🔳⚫️⚪️🔴🔵🔻⬜️⬛️🔶🔷🔸🔹";
        NSMutableString *mString = [[NSMutableString alloc] initWithBytes:"\xD8\x3C\xDC\x00\x00\x2D\xD8\x3C\xDC\xCF\xD8\x3C\xDD\x91\x00\x2D\xD8\x3C\xDD\x9A\xD8\x3C\xDE\x01\x00\x2D\xD8\x3C\xDE\x51\xD8\x3C\xDF\x00\x00\x2D\xD8\x3C\xDF\xF0\xD8\x3D\xDE\x00\x00\x2D\xD8\x3D\xDE\xC5\xD8\x3D\xDD\x00\x00\x2D\xD8\x3D\xDD\xFE\xD8\x3D\xDC\x00\x00\x2D\xD8\x3D\xDC\xFC\x25\xFB\x00\x2D\x25\xFE\x26\x00\x00\x2D\x26\xFD\x27\x02\x00\x2D\x27\x64\x27\x95\x00\x2D\x27\x97\x27\xBF\x27\xB0\x20\xE3\xD8\x3C\xDD\x70\xD8\x3C\xDD\x71\xD8\x3C\xDD\x8E\xD8\x3C\xDD\x7E\xD8\x3C\xDD\x7F" length:7*(2+4*2)+4*(2+2*2)+3*2+5*4 encoding:NSUTF16BigEndianStringEncoding];
        
        [mString appendString:@"⬜️⬛️⭕️‼️⁉️©®™⤵️⤴️ℹ️⬆️⬇️⬅️➡️◀️⭐️🇯🇵🇰🇷🇩🇪🇨🇳🇺🇸🇫🇷🇪🇸🇮🇹🇷🇺🇬🇧"];
        
        instance = [NSString stringWithString:mString];
    });
    
    return instance;
}


static NSString* externRegex()
{
    static id instance;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        instance = @"\uFF00-\uFFFF0-9a-zA-Z\u2e80-\ufe4f\u2190-\u25b6\u2660-\u2667\u0391-\u03A9\u261c-\u261f\u270c-\u2712-\u2133";
    });
    
    return instance;
}

static NSString* regexFilterString()
{
    NSMutableString * mRegexString = [[NSMutableString alloc] initWithString: @"[^\\\\\\[~!`@#$%^&*(){}_+-=|<>\"?:,./;'，。、‘：“”《》－＋——＝＊％～｀＃？~！¥……（）｛｝\\]\\s"];
    [mRegexString appendString:externRegex()];
    [mRegexString appendString:emojiRegex()];
    [mRegexString appendString:@"]+"];
    
    return [NSString stringWithString:mRegexString];
}

+ (NSString *)cleanSpecialTextByReplacingControlCharacter:(NSString *)text
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"[\x00-\x08\x0B\x0C\x0E-\x1F\x7F\u034F\u076E-\u077F\u0787\u0788\uFDF2\u0E31\u05E4\u0332\u032F\u0793\u0799\uFEEC\u06AA\u0361\u2000-\u200F\u2011\u2028-\u202F\u205F-\u206F]+"
                                  options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
    
    return modifiedString;
}


- (NSString *)cleanSpecialText
{
#if DealSpecialString
//    if([[YYUtility systemVersion] floatValue] >= 8.0) {
//        return self;
//    }
    
    NSString* encodeString = self;
    
    //    encodeString = [self cleanSpecialTextByReplacingControlCharacter:string];
    //
    //    // 检核size能否计算
    //    /*
    //     * 通过转码 再算size
    //     */
    //
    //    UIFont *sysFont = [UIFont systemFontOfSize:14];
    //    UIFont *font = [UIFont fontWithName:sysFont.fontName size:14];
    //    CGSize size = [encodeString sizeWithAttributes:@{NSFontAttributeName: (font?:[UIFont systemFontOfSize:14])}];
    //
    //    NSString *str2 = [NSString stringWithFormat:@"%f", size.width];
    //    if ([str2 isEqualToString:@"nan"]) {
    //        [YYLogger info:@"SpecialText" message:@"SpecialText :%@ ##NoCTRLChar## %@", string, encodeString];
    //
    //        [FeedbackUtil feedbackWithComment:@"特殊字符开发人员自动上报" success:^{
    //
    //        } failure:^{
    //
    //        }];
    //
    //        encodeString = [self cleanSpecialTextByReplacingSpecialCharacter:encodeString];
    //    }
    
    encodeString = [self cleanSpecialTextByReplacingSpecialCharacter:encodeString];
    
    return encodeString?encodeString:@"";
#else
    return self;
#endif
}


@end
