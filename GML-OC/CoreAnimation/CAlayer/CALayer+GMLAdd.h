//
//  CALayer+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/8/3.
//

#import <QuartzCore/QuartzCore.h>
#import <GML_OC/YMLineGradientTypeHeader.h>
NS_ASSUME_NONNULL_BEGIN

@interface CALayer (GMLAdd)

+ (void)disableDefaultAnimatedsWithBlock:(void (NS_NOESCAPE ^) (void))block;

+ (instancetype)createLayerWithBackgroundColor:(nullable CGColorRef)backgroundColor;

@end

@interface CAGradientLayer (GMLAdd)

+ (instancetype)createLineGradientWithType:(YMLineGradientType)type startColor:(nullable CGColorRef)startColor endColor:(nullable CGColorRef)endColor;

- (void)setupLineGradientWithType:(YMLineGradientType)type startColor:(nullable CGColorRef)startColor endColor:(nullable CGColorRef)endColor;

/// 设置渐变
/// @param type 渐变类型
/// @param colors NSArray 包含的元素 UIColor/CGColorRef
- (void)setupLineGradientWithType:(YMLineGradientType)type colors:(NSArray *)colors;

@end

NS_ASSUME_NONNULL_END
