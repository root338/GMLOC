//
//  GMLArrowBubbleControl.m
//  QuickAskCommunity
//
//  Created by apple on 2020/6/10.
//  Copyright © 2020 ym. All rights reserved.
//

#import "GMLArrowBubbleControl.h"

#import "GMLMultiAngleView.h"
#import <GML_OC/GMLRadianAngle.h>
#import <GML_OC/CGGeometry+GMLAdd.h>
#import <GML_OC/NSArray+GMLAdd.h>

typedef struct {
    CGRect contentViewFrame;
    CGRect bubbleFrame;
    CGPoint v;
    CGPoint p1;
    CGPoint p2;
} YMArrowBubbleAreaInfo;

@interface GMLArrowBubbleControl ()

@property (nonatomic, strong, readwrite) GMLMultiAngleView *bubbleView;
@end

@implementation GMLArrowBubbleControl

- (instancetype)init {
    self = [super init];
    if (self) {
        _animated = YES;
        _arrowLenght = 5;
        _arrowAngle = 90;
        _isEnableFillet = YES;
        _levelInToView = -1;
        _arrowLocation = GMLArrowLocationBottom;
    }
    return self;
}

- (void)showToView:(UIView *)toView vertexView:(UIView *)vertexView offset:(CGPoint)offset {
    NSAssert(vertexView.superview != nil, @"顶点视图没有添加到父视图");
    NSAssert(!CGRectEqualToRect(vertexView.frame, CGRectZero), @"顶点视图没有frame");
    CGPoint vertexPoint = [vertexView.superview convertPoint:[self _vertexPointWithVertexRect:vertexView.frame location:self.arrowLocation] toView:toView];
    vertexPoint = GMLPointAddPoint(vertexPoint, offset);
    self.vertexPoint = vertexPoint;
    [self showToView:toView];
}

- (void)showToView:(UIView *)toView vertexPoint:(CGPoint)vertexPoint {
    self.vertexPoint = vertexPoint;
    [self showToView:toView];
}

- (void)showToView:(UIView *)toView {
    if (_levelInToView < 0) {
        if (self.bubbleView.superview == toView) { return; }
        [toView addSubview:self.bubbleView];
    }else {
        [toView insertSubview:self.bubbleView atIndex:_levelInToView];
    }
    [self updateContent];
    [self handleAnimatedWithIsShow:YES];
}

- (void)hide {
    [self handleAnimatedWithIsShow:NO];
}

- (void)updateContent {
//    if ([self.delegate respondsToSelector:@selector(bubbleControl:setCustomViewLayoutWithView:)]) {
//        [self.delegate bubbleControl:self setCustomViewLayoutWithView:self.bubbleView];
//        return;
//    }
    
    CGSize maxSize = GMLSizeLessInsets(self.bubbleView.superview.bounds.size, _marginInsets);
    NSAssert(maxSize.width > 1 && maxSize.height > 1, @"气泡没有区域可以显示，请查看显示视图size，或 marginInsets 属性的值");
    CGSize customViewSize;
    if ([self.delegate respondsToSelector:@selector(bubbleControl:customViewSize:)]) {
        customViewSize = [self.delegate bubbleControl:self customViewSize:_customView];
    }else {
        customViewSize = [_customView sizeThatFits:maxSize];
    }
    NSAssert(customViewSize.width > 1 && customViewSize.height > 1, @"气泡视图大小为0");
    CGSize bubbleViewContentSize = GMLSizeAddInsets(customViewSize, _contentInsets);
    // 气泡可使用区域
    CGRect availableRect = CGRectMake(_marginInsets.left, _marginInsets.top, maxSize.width, maxSize.height);
    YMArrowBubbleAreaInfo areaInfo = [self _getPointsWithContentSize:bubbleViewContentSize availableRect:availableRect];
    
    id<GMLMultiAngleProtocol> layer = _bubbleView.targetLayer;
    BOOL isRelease = NO;
    CGPathRef targetPath;
    if ([self.delegate respondsToSelector:@selector(pathWithBubbleControl:isRelease:)]) {
       targetPath = [self.delegate pathWithBubbleControl:self isRelease:&isRelease];
    }else {
        isRelease = YES;
        targetPath = [self _createPathWithAreaInfo:areaInfo];
    }
    layer.path = targetPath;
    if (isRelease) {
        CGPathRelease(targetPath);
    }
    _customView.frame = CGRectMake(_contentInsets.left, _contentInsets.top, customViewSize.width, customViewSize.height);
    if (_customView.superview != self.bubbleView) {
        [self.bubbleView addSubview:_customView];
    }
    self.bubbleView.frame = areaInfo.bubbleFrame;
}

- (void)setupLineGradientWithType:(YMLineGradientType)type colorValueSet:(NSArray<UIColor *> *)colorValueSet {
    id<GMLMultiAngleProtocol> layer = [(GMLMultiAngleView *)self.bubbleView targetLayer];
    layer.gradientType = type;
    layer.gradientColors = colorValueSet;
}

#pragma mark - Private
- (CGPoint)_vertexPointWithVertexRect:(CGRect)rect location:(GMLArrowLocation)location {
    switch (location) {
        case GMLArrowLocationTop:
            return CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        case GMLArrowLocationLeft:
            return CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
        case GMLArrowLocationBottom:
            return CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        case GMLArrowLocationRight:
            return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    }
}

/// 获取箭头三个的坐标 p1, p2, v1 和气泡的 frame
/// @param contentSize 自定义视图的大小
/// @param availableRect 气泡总的可用区域
- (YMArrowBubbleAreaInfo)_getPointsWithContentSize:(CGSize)contentSize availableRect:(CGRect)availableRect {
    //                    v1
    // 顺时针沿边查看 --p1-------p2----
    //                    v1
    __block YMArrowBubbleAreaInfo areaInfo;
    CGFloat arrowHeight;
    CGRect bubbleExpectRect;
    if ([self.delegate respondsToSelector:@selector(bubbleControl:contentSize:availableRect:)]) {
        YMArrowBubbleArrowInfo arrowAreaInfo = [self.delegate bubbleControl:self contentSize:contentSize availableRect:availableRect];
        arrowHeight = arrowAreaInfo.height;
        bubbleExpectRect = arrowAreaInfo.bubbleExpectRect;
        areaInfo.p1 = arrowAreaInfo.p1;
        areaInfo.p2 = arrowAreaInfo.p2;
    }else {
        
        CGFloat radian = GMLAngleToRadian(_arrowAngle / 2);
        arrowHeight = cos(radian) * _arrowLenght;
        CGFloat arrowWidth = sin(radian) * _arrowLenght;
        switch (_arrowLocation) {
            case GMLArrowLocationTop:
                areaInfo.p1 = CGPointMake(_vertexPoint.x - arrowWidth, _vertexPoint.y + arrowHeight);
                areaInfo.p2 = CGPointMake(_vertexPoint.x + arrowWidth, _vertexPoint.y + arrowHeight);
                bubbleExpectRect = CGRectMake(_vertexPoint.x - contentSize.width / 2, _vertexPoint.y, contentSize.width, contentSize.height + arrowHeight);
                break;
            case GMLArrowLocationLeft:
                areaInfo.p1 = CGPointMake(_vertexPoint.x - arrowHeight, _vertexPoint.y + arrowWidth);
                areaInfo.p2 = CGPointMake(_vertexPoint.x - arrowHeight, _vertexPoint.y - arrowWidth);
                bubbleExpectRect = CGRectMake(_vertexPoint.x, _vertexPoint.y - contentSize.height / 2, contentSize.width + arrowHeight, contentSize.height);
                break;
            case GMLArrowLocationBottom:
                areaInfo.p1 = CGPointMake(_vertexPoint.x + arrowWidth, _vertexPoint.y - arrowHeight);
                areaInfo.p2 = CGPointMake(_vertexPoint.x - arrowWidth, _vertexPoint.y - arrowHeight);
                if (_contentOffsetX == 0) {
                    _contentOffsetX = contentSize.width / 2;
                }
                bubbleExpectRect = CGRectMake(_vertexPoint.x - _contentOffsetX, _vertexPoint.y - arrowHeight - contentSize.height, contentSize.width, contentSize.height + arrowHeight);
                break;
            case GMLArrowLocationRight:
                areaInfo.p1 = CGPointMake(_vertexPoint.x + arrowHeight, _vertexPoint.y - arrowWidth);
                areaInfo.p2 = CGPointMake(_vertexPoint.x + arrowHeight, _vertexPoint.y + arrowWidth);
                bubbleExpectRect = CGRectMake(_vertexPoint.x - arrowHeight - contentSize.width, _vertexPoint.y - contentSize.height / 2, contentSize.width + arrowHeight, contentSize.height);
                break;
        }
    }
    
    void (^handleArrowPoint) (CGRect) = ^(CGRect frame) {
        CGPoint offset = CGPointMake(-CGRectGetMinX(frame), -CGRectGetMinY(frame));
        areaInfo.p1 = GMLPointAddPoint(areaInfo.p1, offset);
        areaInfo.p2 = GMLPointAddPoint(areaInfo.p2, offset);
        areaInfo.v = GMLPointAddPoint(self.vertexPoint, offset);
        
        areaInfo.contentViewFrame = (CGRect){
            self.arrowLocation == GMLArrowLocationLeft ? arrowHeight : 0,
            self.arrowLocation == GMLArrowLocationTop ? arrowHeight : 0,
            CGRectGetWidth(frame) -
            ((self.arrowLocation == GMLArrowLocationLeft ||
              self.arrowLocation == GMLArrowLocationRight) ? arrowHeight : 0),
            CGRectGetHeight(frame) -
            ((self.arrowLocation == GMLArrowLocationTop ||
              self.arrowLocation == GMLArrowLocationBottom) ? arrowHeight : 0)
        };
        areaInfo.bubbleFrame = frame;
    };
    
    CGRect bubbleRect = bubbleExpectRect;
    if (CGRectContainsRect(availableRect, bubbleRect)) {
        handleArrowPoint(bubbleRect);
        return areaInfo;
    }
    bubbleRect.size = GMLMinSize(bubbleRect.size, availableRect.size);
    if (CGRectGetMinX(bubbleRect) < CGRectGetMinX(availableRect)) {
        bubbleRect.origin.x = availableRect.origin.x;
    }else if (CGRectGetMaxX(bubbleRect) > CGRectGetMaxX(availableRect)) {
        bubbleRect.origin.x = CGRectGetMaxX(availableRect) - CGRectGetWidth(bubbleRect);
    }
    if (CGRectGetMinY(bubbleRect) < CGRectGetMinY(availableRect)) {
        bubbleRect.origin.y = availableRect.origin.y;
    }else if (CGRectGetMaxY(bubbleRect) > CGRectGetMaxY(availableRect)) {
        bubbleRect.origin.y = CGRectGetMaxY(availableRect) - CGRectGetHeight(bubbleRect);
    }
    handleArrowPoint(bubbleRect);
    return areaInfo;
}

- (CGMutablePathRef)_createPathWithAreaInfo:(YMArrowBubbleAreaInfo)areaInfo {
    
    CGRect contentRect = areaInfo.contentViewFrame;
    YMMultiCornerRadius cornerRadius = _isEnableFillet ? YMMultiCornerRadiusValue(MIN(CGRectGetWidth(contentRect), CGRectGetHeight(contentRect)) / 2) : _multiCornerRadius;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, areaInfo.p1.x, areaInfo.p1.y);
    CGPathAddLineToPoint(path, NULL, areaInfo.v.x, areaInfo.v.y);
    CGPathAddLineToPoint(path, NULL, areaInfo.p2.x, areaInfo.p2.y);
    
    CGPoint (^getVertexPath) (NSInteger) = ^(NSInteger value) {
        BOOL isMinX = value / 10;
        BOOL isMinY = value % 10;
        return CGPointMake(isMinX ? CGRectGetMinX(contentRect) : CGRectGetMaxX(contentRect), isMinY ? CGRectGetMinY(contentRect) : CGRectGetMaxY(contentRect));
    };
    
    void (^addVertexPath) (UIRectCorner) = ^(UIRectCorner corner) {
        //--(11)---------(01)---
        // |                   |
        // |                   |
        // |                   |
        //--(10)---------(00)---
        CGPoint p1, p2;
        CGFloat radius = 0;
        switch (corner) {
            case UIRectCornerTopLeft:
                p1 = getVertexPath(11);
                p2 = getVertexPath(1);
                radius = cornerRadius.topLeft;
                break;
            case UIRectCornerTopRight:
                p1 = getVertexPath(1);
                p2 = getVertexPath(0);
                radius = cornerRadius.topRight;
                break;
            case UIRectCornerBottomLeft:
                p1 = getVertexPath(10);
                p2 = getVertexPath(11);
                radius = cornerRadius.bottomLeft;
                break;
            case UIRectCornerBottomRight:
                p1 = getVertexPath(0);
                p2 = getVertexPath(10);
                radius = cornerRadius.bottomRight;
                break;
            default:
                NSAssert(NO, @"不支持其它值");
                break;
        }
        CGPathAddArcToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, radius);
    };
    
    NSArray *vertexs = @[
        @(UIRectCornerTopLeft),
        @(UIRectCornerTopRight),
        @(UIRectCornerBottomRight),
        @(UIRectCornerBottomLeft),
    ];
    NSInteger startIndex = 0;
    switch (_arrowLocation) {
        case GMLArrowLocationTop:
            startIndex = 1;break;
        case GMLArrowLocationBottom:
            startIndex = 3;break;
        case GMLArrowLocationRight:
            startIndex = 2;break;
        case GMLArrowLocationLeft:
            startIndex = 0;break;
    }
    for (NSInteger i = 0; i < 4; i++) {
        addVertexPath([[vertexs objectAtCycleIndex:startIndex++] integerValue]);
    }
    CGPathAddLineToPoint(path, NULL, areaInfo.p1.x, areaInfo.p1.y);
    return path;
}

- (void)handleAnimatedWithIsShow:(BOOL)isShow {
    
//    if ([self.delegate respondsToSelector:@selector(bubbleControl:setAnimatedWithIsShow:)]) {
//        [self.delegate bubbleControl:self setAnimatedWithIsShow:isShow];
//        return;
//    }
    UIView *targetView = self.bubbleView;
    if (!_animated) {
        if (isShow) { return; }
        [targetView removeFromSuperview];
        return;
    }
    
    CGRect fromFrame, toFrame;
    CGFloat fromAlpha, toAlpha;
    if (isShow) {
        fromFrame = self.bubbleView.frame;
        fromFrame.origin.y += CGRectGetHeight(fromFrame) / 2;
        toFrame = self.bubbleView.frame;
        fromAlpha = 0.1;
        toAlpha = 1;
    }else {
        fromFrame = self.bubbleView.frame;
        toFrame = fromFrame;
        toFrame.origin.y += CGRectGetHeight(fromFrame) / 2;
        toAlpha = 0.1;
        fromAlpha = 1;
    }
    targetView.frame = fromFrame;
    targetView.alpha = fromAlpha;
    [UIView animateWithDuration:0.3 animations:^{
        targetView.frame = toFrame;
        targetView.alpha = toAlpha;
    } completion:^(BOOL finished) {
        if (!isShow) {
            [targetView removeFromSuperview];
        }
    }];
}

#pragma mark - Getter & Setter

- (void)setCustomView:(UIView *)customView {
    if (_customView == customView) {
        return;
    }
    _customView = customView;
    if (customView) {
        [customView removeFromSuperview];
    }
}

- (GMLMultiAngleView *)bubbleView {
    if (_bubbleView == nil) {
        _bubbleView = GMLMultiAngleView.new;
    }
    return _bubbleView;
}

- (void)setGradientLocations:(NSArray<NSNumber *> *)gradientLocations {
    if (gradientLocations && ![_gradientLocations isEqualToArray:gradientLocations]) {
        return ;
    }
    _gradientLocations = [gradientLocations copy];
    [(GMLMultiAngleView *)self.bubbleView targetLayer].gradientLocations = gradientLocations;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    _multiCornerRadius = YMMultiCornerRadiusValue(cornerRadius);
}

- (void)setMultiCornerRadius:(YMMultiCornerRadius)r {
    _multiCornerRadius = r;
    CGFloat tV = r.topLeft;
    _cornerRadius = (tV == r.topRight && tV == r.bottomRight && tV == r.bottomLeft) ? tV : 0;
}

@end
