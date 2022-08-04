//
//  CALayer+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/8/3.
//

#import <QuartzCore/QuartzCore.h>
#import <GML_OC/GMLLineGradientTypeHeader.h>
NS_ASSUME_NONNULL_BEGIN

@interface CALayer (GMLAdd)

/// 禁止默认动画
+ (void)disableDefaultAnimatedsWithBlock:(void (NS_NOESCAPE ^) (void))block;

/// 创建一个层
/// 当导入 UIKit/UIScreen.h 时，contentsScale 自动设置为 UIScreen.mainScreen.scale
+ (instancetype)createLayerWithBackgroundColor:(nullable CGColorRef)backgroundColor;

@end

@interface CAGradientLayer (GMLAdd)

+ (instancetype)createLineGradientWithType:(GMLLineGradientType)type startColor:(nullable CGColorRef)startColor endColor:(nullable CGColorRef)endColor;

- (void)setupLineGradientWithType:(GMLLineGradientType)type startColor:(nullable CGColorRef)startColor endColor:(nullable CGColorRef)endColor;

/// 设置渐变
/// @param type 渐变类型
/// @param colors NSArray 包含的元素 UIColor/CGColorRef
- (void)setupLineGradientWithType:(GMLLineGradientType)type colors:(NSArray *)colors;

@end

NS_ASSUME_NONNULL_END
