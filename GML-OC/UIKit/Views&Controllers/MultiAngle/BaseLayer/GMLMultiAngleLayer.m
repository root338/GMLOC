//
//  GMLMultiAngleLayer.m
//  QuickAskCommunity
//
//  Created by apple on 2020/5/26.
//  Copyright © 2020 ym. All rights reserved.
//

#import "GMLMultiAngleLayer.h"
#import <UIKit/UIColor.h>
#import <UIKit/UIBezierPath.h>
#import <GML_OC/CALayer+GMLAdd.h>
#import <GML_OC/CGGeometry+GMLAdd.h>
#import <GML_OC/GMLPropertyMacro.h>

@interface GMLMultiAngleLayer ()
{
    
}

/// 上一个设置的层
@property (nonatomic, strong) CALayer *previousLayer;
/// 是否需要更新自身外观
@property (nonatomic, assign) BOOL shouldUpdateSelfAppearance;
/// 是否需要更新路径
@property (nonatomic, assign) BOOL shouldUpdatePath;
/// 是否使用自定义渐变坐标
@property (nonatomic, assign) BOOL isUsingCustomGradientPoint;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, assign) CGFloat lineWidth;
/// 根据外部属性自动生成的路径
@property (nonatomic, strong) UIBezierPath *privateBezierPath;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation GMLMultiAngleLayer

@synthesize gradientLocations = _gradientLocations;
@synthesize radiusValue = _radiusValue;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lineWidth = 0.5;
        _gradientType = GMLLineGradientTypeHorizontal;
    }
    return self;
}

- (void)dealloc
{
    if (_path) {
        CGPathRelease(_path);
    }
}

#pragma mark - Public
- (void)setGradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    _startPoint = startPoint;
    _endPoint = endPoint;
    _isUsingCustomGradientPoint = YES;
    _shouldUpdatePath = YES;
    [self setNeedsLayout];
}

#pragma mark - override system method

- (void)layoutSublayers {
    [super layoutSublayers];
    [self _configSubLayoutsContent];
}

#pragma mark - Private

- (void)_configBlock:(void(NS_NOESCAPE^)(void))block {
    if (_disableDefaultAnimation) {
        [CALayer disableDefaultAnimatedsWithBlock:block];
    }else {
        !block?:block();
    }
}

- (void)_configSubLayoutsContent {
    if ([self _selfIsSupport]) {
        !_shouldUpdateSelfAppearance?:[self _setSelfAppearance];
        return;
    }
    if (self.previousLayer == nil || _shouldUpdateSelfAppearance) {
        [self _resetSelfAppearance];
    }
    
    if ([self _isNeedContentLayer]) {
        [self _setContentLayer];
    }else {
        self.previousLayer = nil;
    }
    if ([self _isNeedMaskLayer]) {
        [self _setContentMaskLayer];
    }else {
        CALayer *maskLayerSuperLayer = _previousLayer?:self;
        maskLayerSuperLayer.mask = nil;
    }
}

/// 设置自身
- (void)_setSelfAppearance {
    [self _configBlock:^{
        if (!CGColorEqualToColor(super.backgroundColor, self.fillColor.CGColor)) {
            super.backgroundColor = self.fillColor.CGColor;
        }
        CGFloat radiusValue = _alwaysFillet ? (CGRectGetHeight(self.bounds) / 2) : self.radiusValue;
        super.cornerRadius = radiusValue;
        super.masksToBounds = _clipsToContentFrame;
        _gradientLayer.hidden = YES;
        _shapeLayer.hidden = YES;
        _previousLayer = nil;
        _shouldUpdateSelfAppearance = NO;
    }];
}
/// 还原自身
- (void)_resetSelfAppearance {
    [self _configBlock:^{
        CGColorRef clearColorRef = UIColor.clearColor.CGColor;
        if (!CGColorEqualToColor(super.backgroundColor, clearColorRef)) {
            super.backgroundColor = clearColorRef;
        }
        super.masksToBounds = NO;
        _shouldUpdateSelfAppearance = NO;
        super.cornerRadius = 0;
    }];
}
/// 设置内容层
- (void)_setContentLayer {
    BOOL isShowGradientLayer = [self _isExistGradient];
    CALayer *currentLayer = isShowGradientLayer ? self.gradientLayer : self.shapeLayer;
    CGRect currentLayerFrame = GMLRectLessInsets(self.bounds, _insets);
    currentLayer.frame = currentLayerFrame;
    if (isShowGradientLayer) {
        [self.gradientLayer setupLineGradientWithType:self.gradientType colors:self.gradientColors];
        if (self.isUsingCustomGradientPoint) {
            self.gradientLayer.startPoint = self.startPoint;
            self.gradientLayer.endPoint = self.endPoint;
        }
        self.gradientLayer.locations = self.gradientLocations;
    }else {
        if ([self _isExistIrregularAngle]) {
            [self _setShapeLayerAppearance:self.shapeLayer];
        }
        if (!CGColorEqualToColor(self.shapeLayer.fillColor, self.fillColor.CGColor)) {
            self.shapeLayer.fillColor = self.fillColor.CGColor;
        }
    }
    if (![self _isNeedMaskLayer] && ![self _isExistIrregularAngle]) {
        CGFloat radiusValue = _alwaysFillet ? (CGRectGetHeight(currentLayerFrame) / 2) : self.radiusValue;
        currentLayer.cornerRadius = radiusValue;
        [super setCornerRadius:radiusValue];
    }else {
        currentLayer.cornerRadius = 0;
    }
    self.previousLayer = currentLayer;
}
/// 设置蒙层
- (void)_setContentMaskLayer {
    CALayer *maskLayer = self.maskLayer;
    CALayer *maskLayerSuperLayer;
    CGRect maskLayerFrame;
    if (_previousLayer) {
        maskLayerSuperLayer = _previousLayer;
        maskLayerFrame = _previousLayer.bounds;
    }else {
        maskLayerSuperLayer = self;
        maskLayerFrame = GMLRectLessInsets(self.bounds, _insets);
    }
    maskLayer.frame = maskLayerFrame;
    [self _setShapeLayerAppearance:self.maskLayer];
    maskLayerSuperLayer.mask = maskLayer;
}

- (void)_setShapeLayerAppearance:(CAShapeLayer *)shapeLayer {
    CGRect maskBounds = shapeLayer.bounds;
    if (!self.path &&
        (_shouldUpdatePath ||
         !CGRectEqualToRect(_privateBezierPath.bounds, maskBounds))) {
        UIBezierPath *bezierPath = nil;
        if ([self _isExistIrregularAngle]) {
            CGMutablePathRef path = [self _createMultiCornerRadiusPath:maskBounds];
            bezierPath = [UIBezierPath bezierPathWithCGPath:path];
            CGPathRelease(path);
        }else {
            CGFloat radiusValue = _alwaysFillet ? (MIN(CGRectGetWidth(maskBounds), CGRectGetHeight(maskBounds)) / 2.0) : self.radiusValue;
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:shapeLayer.bounds byRoundingCorners:self.rectCorner cornerRadii:CGSizeMake(radiusValue, radiusValue)];
        }
        bezierPath.lineWidth = self.lineWidth;
        self.privateBezierPath = bezierPath;
        _shouldUpdatePath = NO;
    }
    shapeLayer.path = self.path?: self.privateBezierPath.CGPath;
}

- (CGMutablePathRef)_createMultiCornerRadiusPath:(CGRect)contentRect {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint (^getVertexPath) (NSInteger) = ^(NSInteger value) {
        BOOL isMinX = value / 10;
        BOOL isMinY = value % 10;
        return CGPointMake(isMinX ? CGRectGetMinX(contentRect) : CGRectGetMaxX(contentRect), isMinY ? CGRectGetMinY(contentRect) : CGRectGetMaxY(contentRect));
    };
    YMMultiCornerRadius cornerRadius = _alwaysFillet ? YMMultiCornerRadiusValue(MIN(CGRectGetWidth(contentRect), CGRectGetHeight(contentRect)) / 2.0) : _radiusEdgeValue;
    UIRectCorner rectCorner = _rectCorner;
    CGFloat (^getRadius) (UIRectCorner) = ^(UIRectCorner corner) {
        CGFloat radius = 0;
        if (!(rectCorner & corner)) {
            return radius;
        }
        switch (corner) {
            case UIRectCornerTopLeft:
                radius = cornerRadius.topLeft;break;
            case UIRectCornerTopRight:
                radius = cornerRadius.topRight;
                break;
            case UIRectCornerBottomLeft:
                radius = cornerRadius.bottomLeft;
                break;
            case UIRectCornerBottomRight:
                radius = cornerRadius.bottomRight;
                break;
            default:break;
        }
        return radius;
    };
    CGPoint topLeft = getVertexPath(11);
    CGPoint topRight = getVertexPath(1);
    CGPoint bottomLeft = getVertexPath(10);
    CGPoint bottomRight = getVertexPath(0);
    CGPathMoveToPoint(path, NULL, topLeft.x, topLeft.y);
    CGPathAddArcToPoint(path, NULL, topRight.x, topRight.y, bottomRight.x, bottomRight.y, getRadius(UIRectCornerTopRight));
    CGPathAddArcToPoint(path, NULL, bottomRight.x, bottomRight.y, bottomLeft.x, bottomLeft.y, getRadius(UIRectCornerBottomRight));
    CGPathAddArcToPoint(path, NULL, bottomLeft.x, bottomLeft.y, topLeft.x, topLeft.y, getRadius(UIRectCornerBottomLeft));
    CGPathAddArcToPoint(path, NULL, topLeft.x, topLeft.y, topRight.x, topRight.y, getRadius(UIRectCornerTopLeft));
    return path;
}

/// 是否需要内容层
- (BOOL)_isNeedContentLayer {
    return !(_clipsToContentFrame && !self._isExistGradient);
}
/// 是否需要蒙层
- (BOOL)_isNeedMaskLayer {
    return _clipsToContentFrame || (self._isExistGradient && self._isExistIrregularAngle) ;
}
/// 是否存在渐变
- (BOOL)_isExistGradient {
    switch (_gradientType) {
        case GMLLineGradientTypeVertical:
        case GMLLineGradientTypeHorizontal:
            return _gradientColors.count > 0 && _gradientColors.count == self.gradientLocations.count;
        default:
            return NO;
    }
}
/// 存在不规则边界
- (BOOL)_isExistIrregularAngle {
    if (self.path) {
        return YES;
    }
    if (_rectCorner == 0
        || (_rectCorner == UIRectCornerAllCorners && [self radiusValueIsEqual])) {
        return NO;
    }
    return YES;
}
/// 自身支持
- (BOOL)_selfIsSupport {
    return ![self _isExistIrregularAngle] && ![self _isExistGradient] && UIEdgeInsetsEqualToEdgeInsets(_insets, UIEdgeInsetsZero);
}
- (BOOL)radiusValueIsEqual {
    YMMultiCornerRadius v1 = self.radiusEdgeValue;
    return v1.topLeft == v1.topRight && v1.topLeft == v1.bottomLeft && v1.topLeft == v1.bottomRight;
}

#pragma mark - override system method
- (void)setBackgroundColor:(CGColorRef)backgroundColor {
    if ([self _selfIsSupport]) {
        if (!CGColorEqualToColor(_fillColor.CGColor, backgroundColor)) {
            _fillColor = [UIColor colorWithCGColor:backgroundColor];
        }
        [self _configBlock:^{
            [super setBackgroundColor:backgroundColor];
        }];
    }else if (!CGColorEqualToColor(_fillColor.CGColor, backgroundColor)) {
        self.fillColor = [UIColor colorWithCGColor:backgroundColor];
    }
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self _configBlock:^{
        [super setCornerRadius:cornerRadius];
    }];
    [self setRadiusValue:cornerRadius];
}
- (void)setOpacity:(float)opacity {
    [self _configBlock:^{
        [super setOpacity:opacity];
    }];
}
- (void)setMasksToBounds:(BOOL)masksToBounds {
    if ([self _selfIsSupport]) {
        _clipsToContentFrame = masksToBounds;
        [self _configBlock:^{
            [super setMasksToBounds:masksToBounds];
        }];
    }else {
        self.clipsToContentFrame = masksToBounds;
    }
}

#pragma mark - Getter & Setter

- (CAShapeLayer *)shapeLayer {
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer createLayerWithBackgroundColor:nil];
    }
    return _shapeLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer createLayerWithBackgroundColor:nil];
    }
    return _gradientLayer;
}

- (CAShapeLayer *)maskLayer {
    if (_maskLayer == nil) {
        _maskLayer = [CAShapeLayer createLayerWithBackgroundColor:nil];
    }
    return _maskLayer;
}

- (void)setPath:(CGPathRef)path {
    if (_path) {
        CGPathRelease(_path);
    }
    if (path) {
        _path = CGPathCreateCopy(path);
    }else {
        _path = nil;
    }
    [self setNeedsLayout];
}

- (void)setRectCorner:(UIRectCorner)rectCorner {
    GMLWriteValueProperty(rectCorner)
    _shouldUpdatePath = YES;
    [self setNeedsLayout];
}

- (void)setFillColor:(UIColor *)fillColor {
    GMLWriteClassCopyProperty(fillColor)
    _shouldUpdateSelfAppearance = YES;
    [self setNeedsLayout];
}

- (void)setRadiusValue:(CGFloat)radiusValue {
    if (_radiusValue == radiusValue) return;
    self.radiusEdgeValue = YMMultiCornerRadiusValue(radiusValue);
}

- (void)setAlwaysFillet:(BOOL)alwaysFillet {
    GMLWriteValueProperty(alwaysFillet)
    _shouldUpdateSelfAppearance = YES;
    [self setNeedsLayout];
}

- (CGFloat)radiusValue {
    if ([self radiusValueIsEqual]) {
        return _radiusEdgeValue.topLeft;
    }
    return 0;
}

- (void)setRadiusEdgeValue:(YMMultiCornerRadius)radiusEdgeValue {
    if (YMMultiCornerRadiusEqualToValue(_radiusEdgeValue, radiusEdgeValue)) {
        return;
    }
    _radiusEdgeValue = radiusEdgeValue;
    if ([self radiusValueIsEqual]) {
        _radiusValue = radiusEdgeValue.topLeft;
    }
    _shouldUpdatePath = YES;
    _shouldUpdateSelfAppearance = YES;
    [self setNeedsLayout];
}

- (void)setClipsToContentFrame:(BOOL)clipsToContentFrame {
    GMLWriteValueProperty(clipsToContentFrame)
    _shouldUpdatePath = YES;
    _shouldUpdateSelfAppearance = YES;
    [self setNeedsLayout];
}

- (void)setInsets:(UIEdgeInsets)insets {
    if (UIEdgeInsetsEqualToEdgeInsets(_insets, insets)) {
        return;
    }
    _insets = insets;
    [self setNeedsLayout];
}

- (void)setGradientType:(GMLLineGradientType)gradientType {
    if (_gradientType == gradientType) {
        return;
    }
    _gradientType = gradientType;
    [self setNeedsLayout];
}
- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors {
    if (gradientColors != nil && [_gradientColors isEqualToArray:gradientColors]) {
        return;
    }
    _gradientColors = [gradientColors copy];
    [self setNeedsLayout];
}

- (NSArray<NSNumber *> *)gradientLocations {
    if (_gradientLocations == nil) {
        _gradientLocations = @[
            @0,
            @1,
        ];
    }
    return _gradientLocations;
}

- (void)setGradientLocations:(NSArray<NSNumber *> *)gradientLocations {
    if (gradientLocations != nil && [_gradientLocations isEqualToArray:gradientLocations]) {
        return;
    }
    _gradientLocations = [gradientLocations copy];
    [self setNeedsLayout];
}

- (void)setPreviousLayer:(CALayer *)previousLayer {
    if (_previousLayer == previousLayer) {
        return;
    }
    _previousLayer.hidden = YES;
    _previousLayer = previousLayer;
    if (previousLayer) {
        previousLayer.hidden = NO;
        if (previousLayer != self.sublayers.firstObject) {
            [self insertSublayer:previousLayer atIndex:0];
        }
    }
}

@end
