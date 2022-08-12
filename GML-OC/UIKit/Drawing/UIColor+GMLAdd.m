//
//  UIColor+GMLAdd.m
//  GML-OC
//
//  Created by GML on 2022/8/11.
//

#import "UIColor+GMLAdd.h"

#import <GML_OC/NSString+GMLAdd.h>

static NSInteger hexValueFromStr(NSString *str) {
    uint32_t result = 0;
    sscanf(str.UTF8String, "%X", &result);
    return result;
}

@implementation UIColor (GMLAdd)

+ (UIColor *)colorWithHexValue:(NSInteger)hex {
    return [self colorWithHexValue:hex alpha:-1];
}
+ (UIColor *)colorWithHexValue:(NSInteger)hex alpha:(CGFloat)alpha {
    NSInteger maxValue = 255.0;
    alpha = (alpha < 0) ? (hex >= 0x01000000 ? ((hex >> 24) / maxValue) : 1) : alpha;
    CGFloat red = (hex >> 16 & 0xFF) / maxValue;
    CGFloat green = (hex >> 8 & 0xFF) / maxValue;
    CGFloat blue = (hex & 0xFF) / maxValue;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hex {
    return [self colorWithHexString:hex alpha:-1];
}
+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha {
    NSString *value = [hex.trimSpace uppercaseString];
    if ([hex hasPrefix:@"#"]) {
        value = [value substringFromIndex:1];
    }else if ([hex hasPrefix:@"0X"]) {
        value = [value substringFromIndex:2];
    }else {
        return nil;
    }
    NSInteger length = value.length;
    if (length != 3 && length != 4 && length != 6 && length != 8) return nil;
    CGFloat red = 0, green = 0, blue = 0, offset = 0;
    if (length < 5) {
        CGFloat maxValue = 15.0;
        if (length == 4) {
            alpha = alpha < 0 ? (hexValueFromStr([value substringWithRange:NSMakeRange(0, 1)]) / maxValue) : alpha;
            offset = 1;
        }
        red = hexValueFromStr([value substringWithRange:NSMakeRange(offset, 1)]) / maxValue;
        green = hexValueFromStr([value substringWithRange:NSMakeRange(offset + 1, 1)]) / maxValue;
        blue = hexValueFromStr([value substringWithRange:NSMakeRange(offset + 2, 1)]) / maxValue;
    }else {
        CGFloat maxValue = 255.0;
        if (length == 8) {
            alpha = alpha < 0 ? (hexValueFromStr([value substringWithRange:NSMakeRange(0, 2)]) / maxValue) : alpha;
            offset = 2;
        }
        red = hexValueFromStr([value substringWithRange:NSMakeRange(offset, 2)]) / maxValue;
        green = hexValueFromStr([value substringWithRange:NSMakeRange(offset + 2, 2)]) / maxValue;
        blue = hexValueFromStr([value substringWithRange:NSMakeRange(offset + 4, 2)]) / maxValue;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha < 0 ? 1 : alpha];
}

@end
