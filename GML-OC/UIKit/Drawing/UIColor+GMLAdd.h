//
//  UIColor+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (GMLAdd)

/// 十六进制数字颜色，支持 ARGB
+ (UIColor *)colorWithHexValue:(NSInteger)hex;
/// 十六进制数字颜色，支持 ARGB
/// @param alpha 透明度，当 alpha < 0 时，hex 存在 A 的话会被使用，否则为 1
+ (UIColor *)colorWithHexValue:(NSInteger)hex alpha:(CGFloat)alpha;

/// 十六进制字符串颜色，支持 ARGB
/// 开头必须为 #/0x/0X，支持短格式如 #FFF
+ (nullable UIColor *)colorWithHexString:(NSString *)hex;
/// 十六进制字符串颜色，支持 ARGB
/// 开头必须为 #/0x/0X，支持短格式如 #FFF
/// @param alpha 透明度，当 alpha < 0 时，hex 存在 A 的话会被使用，否则为 1
+ (nullable UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
