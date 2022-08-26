//
//  GMLMultiAngleLayer.h
//  QuickAskCommunity
//
//  Created by apple on 2020/5/26.
//  Copyright © 2020 ym. All rights reserved.
//

#import <GML_OC/GMLMultiAngleProtocol.h>

NS_ASSUME_NONNULL_BEGIN

/// 不规则形层
@interface GMLMultiAngleLayer : CALayer<GMLMultiAngleProtocol>

/// 截取内容 frame 之外的区域
@property (nonatomic, assign) BOOL clipsToContentFrame;
/// 内容边距
@property (nonatomic, assign) UIEdgeInsets insets;
/// 边角的设置
@property (nonatomic, assign) UIRectCorner rectCorner;
/// 总是圆角
@property (nonatomic, assign) BOOL alwaysFillet;
/// 角的弧度，四周的角
@property (nonatomic, assign) CGFloat radiusValue;
/// 内容填充的颜色
@property (nullable, nonatomic, copy) UIColor *fillColor;
/// 路径设置，可以设置不同形状，外部创建的CGPath需要外部自己释放
@property (nullable, nonatomic) CGPathRef path;
/// 每个角的半径值
@property (nonatomic, assign) YMMultiCornerRadius radiusEdgeValue;
/// 渐变的类型
@property (nonatomic, assign) GMLLineGradientType gradientType;
/// 关闭默认动画
@property (nonatomic, assign) BOOL disableDefaultAnimation;
/// 渐变的颜色
@property (nullable, nonatomic, copy) NSArray<UIColor *> *gradientColors;
/// 渐变颜色位置，默认 [0, 1]
@property (nullable, nonatomic, copy) NSArray<NSNumber *> *gradientLocations;
/// 自定义设置渐变的坐标，调用此方法会忽略 gradientType 属性值
- (void)setGradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
