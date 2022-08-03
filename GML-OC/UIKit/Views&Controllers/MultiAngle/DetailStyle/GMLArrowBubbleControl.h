//
//  GMLArrowBubbleControl.h
//  QuickAskCommunity
//
//  Created by apple on 2020/6/10.
//  Copyright © 2020 ym. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <UIKit/UIGeometry.h>
#import <CoreGraphics/CGGeometry.h>

#import "GMLMultiAngleDefineHeader.h"
#import "YMLineGradientTypeHeader.h"

NS_ASSUME_NONNULL_BEGIN
@class GMLArrowBubbleControl, UIView, UIColor;

/// 顺时针下气泡端点
typedef struct {
    CGPoint p1;
    CGPoint p2;
    CGFloat height;
    CGRect bubbleExpectRect; // 除去顶点描述的区域外的区域
} YMArrowBubbleArrowInfo;

typedef NS_ENUM(NSInteger, GMLArrowLocation) {
    GMLArrowLocationTop,
    GMLArrowLocationLeft,
    GMLArrowLocationBottom,
    GMLArrowLocationRight
};

@protocol GMLArrowBubbleControlDelegate <NSObject>

@optional

/// 设置自定义视图布局
/// 实现此方法需要设置气泡视图的frame
/// @param bubbleControl 气泡控制器
/// @param view 气泡视图
//- (void)bubbleControl:(GMLArrowBubbleControl *)bubbleControl setCustomViewLayoutWithView:(UIView *)view;

- (YMArrowBubbleArrowInfo)bubbleControl:(GMLArrowBubbleControl *)bubbleControl contentSize:(CGSize)contentSize  availableRect:(CGRect)availableRect;
/// 自定义配置气泡的形状路径
/// @param isRelease 是否需要释放
- (CGPathRef)pathWithBubbleControl:(GMLArrowBubbleControl *)bubbleControl isRelease:(BOOL *)isRelease;
/// 自定义设置动画显示效果
- (void)bubbleControl:(GMLArrowBubbleControl *)bubbleControl setAnimatedWithIsShow:(BOOL)isShow;

/// 获取内容视图的大小
- (CGSize)bubbleControl:(GMLArrowBubbleControl *)bubbleControl customViewSize:(nullable UIView *)customView;
@end

@interface GMLArrowBubbleControl<__covariant ObjectType: UIView *> : NSObject

@property (nonatomic, strong, readonly) __kindof UIView *bubbleView;
@property (nonatomic, weak) id<GMLArrowBubbleControlDelegate> delegate;
/**
 * 自定义视图
 * 该视图大小的设置：
 * 1. 通过 customView sizeThatFits: 计算
 * 2. 实现 bubbleControl:customViewSize: 代理方法
 */
@property (nullable, nonatomic, strong) ObjectType customView;
/// 显示隐藏是否执行默认动画, 默认 YES
@property (nonatomic, assign) BOOL animated;
/// 气泡外边距
@property (nonatomic, assign) UIEdgeInsets marginInsets;
/// customView 视图与气泡内容之间的间距, 不包含角区域
@property (nonatomic, assign) UIEdgeInsets contentInsets;
/// 顶角的坐标
@property (nonatomic, assign) CGPoint vertexPoint;
/// 以顶角的坐标为初始点内容视图x坐标偏移量，顶角与内容视图左边的距离(目前只有CGViewPositionStyleBottom生效，如其他需要自行添加)
@property (nonatomic, assign) CGFloat contentOffsetX;
/// 箭头边长，默认 5
@property (nonatomic, assign) CGFloat arrowLenght;
/// 箭头角度, 默认 90
@property (nonatomic, assign) CGFloat arrowAngle;
/// 气泡的圆角值，multiCornerRadius 属性各值相等才有值
@property (nonatomic, assign) CGFloat cornerRadius;
/// 气泡每个角的弧度值
@property (nonatomic, assign) YMMultiCornerRadius multiCornerRadius;
/// 开启半圆角，默认 YES, 忽略 cornerRadius, multiCornerRadius 属性
@property (nonatomic, assign) BOOL isEnableFillet;
/// 箭头在边的位置，默认 GMLArrowLocationBottom
@property (nonatomic, assign) GMLArrowLocation arrowLocation;
/// 气泡添加到视图的层级，默认 -1,
@property (nonatomic, assign) NSInteger levelInToView;
/// 渐变位置，默认[0, 1]
@property (nullable, nonatomic, copy) NSArray<NSNumber *> *gradientLocations;

/// 设置渐变
- (void)setupLineGradientWithType:(YMLineGradientType)type colorValueSet:(NSArray<UIColor *> *)colorValueSet;

- (void)showToView:(UIView *)toView;
- (void)showToView:(UIView *)toView vertexPoint:(CGPoint)vertexPoint;
/// 显示气泡视图
/// @param toView 气泡添加到的视图
/// @param vertexView 根据 arrowLocation的变化而变化,例: CGViewPositionStyleBottom 时 取顶点视图 {vertexView.midX, vertexView.y}
- (void)showToView:(UIView *)toView vertexView:(UIView *)vertexView offset:(CGPoint)offset;
- (void)hide;

/// 更新内容，在调用showToView:时会自动执行一次
- (void)updateContent;

@end

NS_ASSUME_NONNULL_END
