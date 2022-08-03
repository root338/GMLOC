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

CG_INLINE BOOL GMLPointIsNAN(CGPoint p1) {
    return isnan(p1.x) || isnan(p1.y);
}

/** 计算 { p1.x + x, p1.y + y } */
CG_INLINE CGPoint GMLPointAddOffset(CGPoint p1, CGFloat x, CGFloat y) {
    return CGPointMake(p1.x + x, p1.y + y);
}

/** 计算 { p1.x + p2.x, p1.y + p2.y } */
CG_INLINE CGPoint GMLPointAddPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

/** 获取 s1 的中心点 */
CG_INLINE CGPoint GMLSizeGetMidPoint(CGSize s1) {
    return CGPointMake(s1.width / 2.0, s1.height / 2.0);
}

/** 获取 s2 在 s1 居中时的起始坐标 */
CG_INLINE CGPoint GMLSizeGetMidPointOfSize(CGSize s1, CGSize s2) {
    return CGPointMake((s2.width - s1.width) / 2.0, (s2.height - s1.height) / 2.0);
}

CG_INLINE CGPoint GMLPointsGetMidPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
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

/** 计算 { { midX - size.width / 2, midY - size.height / 2 }, { size } */
CG_INLINE CGRect GMLSizeCenterOfRect(CGSize size, CGRect rect) {
    return CGRectMake(CGRectGetMidX(rect) - size.width / 2,
                      CGRectGetMidY(rect) - size.height / 2,
                      size.width,
                      size.height
                      );
}

#if __has_include(<UIKit/UIView.h>)
#import <UIKit/UIView.h>

CG_INLINE CGRect GMLRectContentMode(CGRect totalRect, CGSize targetSize, UIViewContentMode mode) {
    CGRect frame = CGRectZero;
    CGSize totalSize = totalRect.size;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = targetSize.width;
    CGFloat height = targetSize.height;
    switch (mode) {
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat s1 = targetSize.width / totalSize.width;
            CGFloat s2 = targetSize.height / totalSize.height;
            if (s1 < s2) {
                if (UIViewContentModeScaleAspectFit == mode) {
                    width   = targetSize.width / s2;
                    height  = totalSize.height;
                }else {
                    width   = totalSize.width;
                    height  = targetSize.height / s1;
                }
            }else {
                if (UIViewContentModeScaleAspectFit == mode) {
                    width   = totalSize.width;
                    height  = targetSize.height / s1;
                }else {
                    width   = targetSize.width / s2;
                    height  = totalSize.height;
                }
            }
            
            x = (width - totalSize.width) / 2;
            y = (height - totalSize.height) / 2;
            break;
        }
        case UIViewContentModeScaleToFill:
            width = totalSize.width;
            height = totalSize.height;
            break;
        case UIViewContentModeTop:
            x = (targetSize.width - totalSize.width) / 2;
            break;
        case UIViewContentModeTopRight:
            x = totalSize.width - targetSize.width;
            break;
        case UIViewContentModeRight:
            x = totalSize.width - targetSize.width;
            y = (targetSize.height - totalSize.height) / 2;
            break;
        case UIViewContentModeBottomRight:
            x = totalSize.width - targetSize.width;
            y = totalSize.height - targetSize.height;
            break;
        case UIViewContentModeBottom:
            x = (targetSize.width - totalSize.width) / 2;
            y = totalSize.height - targetSize.height;
            break;
        case UIViewContentModeBottomLeft:
            y = totalSize.height - targetSize.height;
            break;
        case UIViewContentModeLeft:
            y = (targetSize.height - totalSize.height) / 2;
            break;
        case UIViewContentModeCenter:
            x = (targetSize.width - totalSize.width) / 2;
            y = (targetSize.height - totalSize.height) /2;
            break;
        default:
            break;
    }
    frame = CGRectMake(x + CGRectGetMinX(totalRect), y + CGRectGetMinY(totalRect), width, height);
    return frame;
}

#endif

///** 忽略顶部 计算 { { x + left, offsetY }, { width - (left + right), height - (offsetY + bottom) } } */
//CG_INLINE CGRect CG_CGRectWithExcludeTop(CGRect rect, UIEdgeInsets edgeInsets, CGFloat offsetY)
//{
//    return CGRectMake(CGRectGetMinX(rect) + edgeInsets.left, CGRectGetMinY(rect) + offsetY, CG_CGWidthWithMaxWidth(CGRectGetWidth(rect), edgeInsets), rect.size.height - (offsetY + edgeInsets.bottom));
//}
//
///// 忽略底部 计算 { { x + left, y + top }, { width - (left + right), height} }
///// @param height 高度，== -1，使用 宽度
//CG_INLINE CGRect CG_CGRectWithExcludeBottom(CGRect rect, UIEdgeInsets edgeInsets, CGFloat height)
//{
//    CGFloat width = CG_CGWidthWithMaxWidth(CGRectGetWidth(rect), edgeInsets);
//    if (height == -1) {
//        height = width;
//    }
//    return CGRectMake(CGRectGetMinX(rect) + edgeInsets.left, CGRectGetMinY(rect) + edgeInsets.top, width, height);
//}
//
///// 忽略垂直 计算 { { x + left, y + offsetY }, { width - (left + right), height } }
///// @param height 高度，== -1，使用 宽度
//CG_INLINE CGRect CG_CGRectWithExcludeVertical(CGRect rect, UIEdgeInsets edgeInsets, CGFloat offsetY, CGFloat height)
//{
//    CGFloat width = CG_CGWidthWithMaxWidth(CGRectGetWidth(rect), edgeInsets);
//    if (height == -1) {
//        height = width;
//    }
//    return CGRectMake(CGRectGetMinX(rect) + edgeInsets.left, CGRectGetMinY(rect) + offsetY, width, height);
//}
//
///// 忽略右边 计算 { {x + left, y + top }, { width , height - (top + bottom) } }
///// @param rect 可用区域
///// @param edgeInsets 外边距
///// @param width 宽度，如果== -1，使用 高度
//CG_INLINE CGRect CG_CGRectWithExcludeRight(CGRect rect, UIEdgeInsets edgeInsets, CGFloat width)
//{
//    CGFloat height = CG_CGHeightWithMaxHeight(CGRectGetHeight(rect), edgeInsets);
//    if (width == -1) {
//        width = height;
//    }
//    return CGRectMake(CGRectGetMinX(rect) + edgeInsets.left, CGRectGetMinY(rect) + edgeInsets.top, width, height);
//}
//
///** 忽略左边 计算 { { x + offsetX, y + top }, { width - (offsetX + right), height - (top + bottom) } }  */
//CG_INLINE CGRect CG_CGRectWithExcludeLeft(CGRect rect, UIEdgeInsets edgeInsets, CGFloat offsetX) {
//    return CGRectMake(CGRectGetMinX(rect) + offsetX, CGRectGetMinY(rect) + edgeInsets.top, CGRectGetWidth(rect) - (offsetX + edgeInsets.right), CG_CGHeightWithMaxHeight(CGRectGetHeight(rect), edgeInsets));
//}
//
///// 忽略水平 计算 { { x + offsetX, y + top }, { width , height - (top + bottom) }
///// @param width 宽度，如果== -1，使用 高度
//CG_INLINE CGRect CG_CGRectWithExcludeHorizontal(CGRect rect, UIEdgeInsets edgeInsets, CGFloat offsetX, CGFloat width)
//{
//    CGFloat height = CG_CGHeightWithMaxHeight(CGRectGetHeight(rect), edgeInsets);
//    if (width == -1) {
//        width = height;
//    }
//    return CGRectMake(CGRectGetMinX(rect) + offsetX, CGRectGetMinY(rect) + edgeInsets.top, width, height);
//}
//
///** 计算 { position, size } */
//CG_INLINE CGRect CG_CGRectWithMake(CGPoint position, CGSize size)
//{
//    return CGRectMake(position.x, position.y, size.width, size.height);
//}
//
///** 计算 { {center.x - width / 2, centr.y - height / 2 }, size } */
//CG_INLINE CGRect CG_CGRectWithCenterMake(CGPoint center, CGSize size)
//{
//    return CGRectMake(center.x - size.width / 2.0, center.y - size.height / 2.0, size.width, size.height);
//}
///** size 在可用区域(availableRect)内，垂直居中 */
//CG_INLINE CGRect CG_CGRectWithCenterVertical(CGRect availableRect, CGSize size)
//{
//    return CGRectMake(CGRectGetMinX(availableRect), CGRectGetMinY(availableRect) + (CGRectGetHeight(availableRect) - size.height) / 2, size.width, size.height);
//}
///** size 在可用区域(availableRect)内，水平居中 */
//CG_INLINE CGRect CG_CGRectWithCenterHorizontal(CGRect availableRect, CGSize size)
//{
//    return CGRectMake(CGRectGetMinX(availableRect) + (CGRectGetWidth(availableRect) - size.width) / 2, CGRectGetMinY(availableRect), size.width, size.height);
//}

#endif /* CGGeometry_GMLAdd_h */
