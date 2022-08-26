//
//  CGGeometry+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/8/3.
//

#ifndef CGGeometry_GMLAdd_h
#define CGGeometry_GMLAdd_h

#import <CoreGraphics/CGGeometry.h>

#if __has_include(<UIKit/UIGeometry.h>)
#import <UIKit/UIGeometry.h>

/** 计算 value - (left + right) */
CG_INLINE CGFloat GMLFloatLessHorizontalInsets(CGFloat value, UIEdgeInsets insets) {
    return value - (insets.left + insets.right);
}
/// value + insets.left + insets.right;
CG_INLINE CGFloat GMLFloatAddHorizontalInsets(CGFloat value, UIEdgeInsets insets) {
    return value + (insets.left + insets.right);
}
/// value + insets.left + insets.right
CG_INLINE CGFloat GMLFloatLessVerticalInsets(CGFloat value, UIEdgeInsets insets) {
    return value - (insets.top + insets.bottom);
}
/// value + insets.left + insets.right
CG_INLINE CGFloat GMLFloatAddVerticalInsets(CGFloat value, UIEdgeInsets insets) {
    return value + (insets.top + insets.bottom);
}
/// { width + left + right,  height + top + bottom }
CG_INLINE CGSize GMLSizeAddInsets(CGSize size, UIEdgeInsets insets) {
    return CGSizeMake(GMLFloatAddHorizontalInsets(size.width, insets), GMLFloatAddVerticalInsets(size.height, insets));
}
/// { width - left - right, height - top - bottom }
CG_INLINE CGSize GMLSizeLessInsets(CGSize size, UIEdgeInsets insets) {
    return CGSizeMake(GMLFloatLessHorizontalInsets(size.width, insets), GMLFloatLessVerticalInsets(size.height, insets));
}

CG_INLINE CGRect GMLRectLessInsets(CGRect rect, UIEdgeInsets insets) {
    return CGRectMake(
                      rect.origin.x + insets.left,
                      rect.origin.y + insets.top,
                      GMLFloatLessHorizontalInsets(rect.size.width, insets),
                      GMLFloatLessVerticalInsets(rect.size.height, insets)
                      );
}

CG_INLINE CGRect GMLRectAddInsets(CGRect rect, UIEdgeInsets insets) {
    return CGRectMake(
                      rect.origin.x - insets.left,
                      rect.origin.y - insets.top,
                      GMLFloatAddHorizontalInsets(rect.size.width, insets),
                      GMLFloatAddVerticalInsets(rect.size.height, insets)
                      );
}

#endif
/// 计算 val1 在 val2 的中点
CG_INLINE CGFloat GMLFloatMidOfMax(CGFloat val1, CGFloat val2) {
    return (val2 - val1) / 2.0;
}

CG_INLINE CGSize GMLMinSize(CGSize s1, CGSize s2) {
    return CGSizeMake(MIN(s1.width, s2.width), MIN(s1.height, s2.height));
}
CG_INLINE CGSize GMLMaxSize(CGSize s1, CGSize s2) {
    return CGSizeMake(MAX(s1.width, s2.width), MAX(s1.height, s2.height));
}
/// {s1.width + s2.width, s1.height + s2.height}
CG_INLINE CGSize GMLSizeAddSize(CGSize s1, CGSize s2) {
    return CGSizeMake(s1.width + s2.width, s1.height + s2.height);
}

/** 获取 s1 的中心点 */
CG_INLINE CGPoint GMLSizeGetMidPoint(CGSize s1) {
    return CGPointMake(s1.width / 2.0, s1.height / 2.0);
}

/** 获取 s1 在 s2 居中时的起始坐标 */
CG_INLINE CGPoint GMLSizeGetMidPointOfSize(CGSize s1, CGSize s2) {
    return CGPointMake((s2.width - s1.width) / 2.0, (s2.height - s1.height) / 2.0);
}

/** 计算 { { midX - size.width / 2, midY - size.height / 2 }, { size } */
CG_INLINE CGRect GMLSizeCenterOfRect(CGSize size, CGRect rect) {
    return CGRectMake(CGRectGetMidX(rect) - size.width / 2,
                      CGRectGetMidY(rect) - size.height / 2,
                      size.width,
                      size.height
                      );
}


/** size 在可用区域(rect)内，垂直居中 */
CG_INLINE CGRect GMLSizeOfRectVerticalCenter(CGSize size, CGRect rect) {
    return CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + (CGRectGetHeight(rect) - size.height) / 2, size.width, size.height);
}
/** size 在可用区域(rect)内，水平居中 */
CG_INLINE CGRect GMLSizeOfRectHorizontalCenter(CGSize size, CGRect rect) {
    return CGRectMake(CGRectGetMinX(rect) + (CGRectGetWidth(rect) - size.width) / 2, CGRectGetMinY(rect), size.width, size.height);
}

CG_INLINE BOOL GMLPointIsNAN(CGPoint p1) {
    return isnan(p1.x) || isnan(p1.y);
}

/** 两个坐标的中点 */
CG_INLINE CGPoint GMLMidPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
}

/** 计算 { p1.x + x, p1.y + y } */
CG_INLINE CGPoint GMLPointAddOffset(CGPoint p1, CGFloat x, CGFloat y) {
    return CGPointMake(p1.x + x, p1.y + y);
}

/** 计算 { p1.x + p2.x, p1.y + p2.y } */
CG_INLINE CGPoint GMLPointAddPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

/// {MIN(p1.x, p2.x), MIN(p1.y, p2.y)}
CG_INLINE CGPoint GMLMinPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake(MIN(p1.x, p2.x), MIN(p1.y, p2.y));
}
// {MAX(p1.x, p2.x), MAX(p1.y, p2.y)}
CG_INLINE CGPoint GMLMaxPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake(MAX(p1.x, p2.x), MAX(p1.y, p2.y));
}

CG_INLINE CGRect GMLRect(CGPoint p, CGSize s) {
    return CGRectMake(p.x, p.y, s.width, s.height);
}

/** 计算 { { 0, 0}, { width, height } } */
CG_INLINE CGRect GMLRectBounds(CGRect rect) {
    return CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
}

/** 忽略顶部 计算 { { x + left, offsetY }, { width - (left + right), height - (offsetY + bottom) } } */
CG_INLINE CGRect GMLRectLessInsetExcludeTop(CGRect rect, UIEdgeInsets insets, CGFloat offsetY) {
    return CGRectMake(CGRectGetMinX(rect) + insets.left, CGRectGetMinY(rect) + offsetY, GMLFloatAddHorizontalInsets(rect.size.width, insets), rect.size.height - (offsetY + insets.bottom));
}

/** 忽略底部 计算 { { x + left, y + top }, { width - (left + right), height} } */
CG_INLINE CGRect GMLRectLessInsetExcludeBottom(CGRect rect, UIEdgeInsets insets, CGFloat height) {
    return CGRectMake(CGRectGetMinX(rect) + insets.left, CGRectGetMinY(rect) + insets.top, GMLFloatAddHorizontalInsets(rect.size.width, insets), height);
}

/** 忽略垂直 计算 { { x + left, y + offsetY }, { width - (left + right), height } } */
CG_INLINE CGRect GMLRectLessInsetExcludeVertical(CGRect rect, UIEdgeInsets insets, CGFloat offsetY, CGFloat height) {
    return CGRectMake(CGRectGetMinX(rect) + insets.left, CGRectGetMinY(rect) + offsetY, GMLFloatAddHorizontalInsets(rect.size.width, insets), height);
}

/** 忽略右边 计算 { {x + left, y + top }, { width , height - (top + bottom) } } */
CG_INLINE CGRect GMLRectLessInsetExcludeRight(CGRect rect, UIEdgeInsets insets, CGFloat width) {
    return CGRectMake(CGRectGetMinX(rect) + insets.left, CGRectGetMinY(rect) + insets.top, width, GMLFloatAddVerticalInsets(rect.size.height, insets));
}

/** 忽略左边 计算 { { x + offsetX, y + top }, { width - (offsetX + right), height - (top + bottom) } }  */
CG_INLINE CGRect GMLRectLessInsetExcludeLeft(CGRect rect, UIEdgeInsets insets, CGFloat offsetX) {
    return CGRectMake(CGRectGetMinX(rect) + offsetX, CGRectGetMinY(rect) + insets.top, CGRectGetWidth(rect) - (offsetX + insets.right), GMLFloatAddVerticalInsets(rect.size.height, insets));
}

/** 忽略水平 计算 { { x + offsetX, y + top }, { width , height - (top + bottom) } */
CG_INLINE CGRect GMLRectLessInsetExcludeHorizontal(CGRect rect, UIEdgeInsets insets, CGFloat offsetX, CGFloat width) {
    return CGRectMake(CGRectGetMinX(rect) + offsetX, CGRectGetMinY(rect) + insets.top, width, GMLFloatAddVerticalInsets(rect.size.height, insets));
}

#if __has_include(<UIKit/UIView.h>)
#import <UIKit/UIView.h>

CG_INLINE CGRect GMLSizeInRect(CGSize size, UIViewContentMode mode, CGPoint offset, CGRect rect) {
    CGSize maxSize = rect.size;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = size.width;
    CGFloat height = size.height;
    switch (mode) {
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill:
        {
            
//            NSAssert(!CGSizeEqualToSize(maxSize, CGSizeZero), @"不能为 0");
            if (CGSizeEqualToSize(maxSize, CGSizeZero)) return CGRectZero;
            CGFloat s1 = size.width / maxSize.width;
            CGFloat s2 = size.height / maxSize.height;
            if (s1 < s2) {
                if (UIViewContentModeScaleAspectFit == mode) {
//                    NSAssert(s2 != 0, @"不能为 0");
                    if (s2 == 0) return CGRectZero;
                    width   = size.width / s2;
                    height  = maxSize.height;
                }else {
//                    NSAssert(s1 != 0, @"不能为 0");
                    if (s1 == 0) return CGRectZero;
                    width   = maxSize.width;
                    height  = size.height / s1;
                }
            }else {
                if (UIViewContentModeScaleAspectFit == mode) {
//                    NSAssert(s1 != 0, @"不能为 0");
                    if (s1 == 0) return CGRectZero;
                    width   = maxSize.width;
                    height  = size.height / s1;
                }else {
//                    NSAssert(s2 != 0, @"不能为 0");
                    if (s2 == 0) return CGRectZero;
                    width   = size.width / s2;
                    height  = maxSize.height;
                }
            }
            
            x = GMLFloatMidOfMax(width, maxSize.width);
            y = GMLFloatMidOfMax(height, maxSize.height);
            break;
        }
        case UIViewContentModeScaleToFill:
            width = maxSize.width;
            height = maxSize.height;
            break;
        case UIViewContentModeTop:
            x = GMLFloatMidOfMax(size.width, maxSize.width);
            break;
        case UIViewContentModeTopRight:
            x = maxSize.width - size.width;
            break;
        case UIViewContentModeRight:
            x = maxSize.width - size.width;
            y = GMLFloatMidOfMax(size.height, maxSize.height);
            break;
        case UIViewContentModeBottomRight:
            x = maxSize.width - size.width;
            y = maxSize.height - size.height;
            break;
        case UIViewContentModeBottom:
            x = GMLFloatMidOfMax(size.width, maxSize.width);
            y = maxSize.height - size.height;
            break;
        case UIViewContentModeBottomLeft:
            y = maxSize.height - size.height;
            break;
        case UIViewContentModeLeft:
            y = GMLFloatMidOfMax(size.height, maxSize.height);
            break;
        case UIViewContentModeCenter: {
            CGPoint p = GMLSizeGetMidPointOfSize(size, maxSize);
            x =  p.x;
            y = p.y;
        }   break;
        default:
            break;
    }
    return CGRectMake(
                      x + rect.origin.x + offset.x,
                      y + rect.origin.y + offset.y,
                      width, height
                      );
}

CG_INLINE CGRect GMLSizeFillInRect(CGSize size, BOOL isFillWidth, BOOL isFillHeight, UIViewContentMode mode, CGPoint offset, CGRect rect) {
    return GMLSizeInRect(CGSizeMake(isFillWidth ? rect.size.width : size.width, isFillHeight ? rect.size.height : size.height), mode, offset, rect);
}

#endif

#endif /* CGGeometry_GMLAdd_h */
