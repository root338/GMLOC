//
//  GMLRect.h
//  GMLOCDemo
//
//  Created by apple on 2020/7/22.
//  Copyright © 2020 GML. All rights reserved.
//

#ifndef GMLRect_h
#define GMLRect_h

#import "GMLFloat.h"

UIKIT_STATIC_INLINE CGRect GMLRectMake(CGPoint p, CGSize s) {
    return CGRectMake(p.x, p.y, s.width, s.height);
}

/** 计算 { {center.x - width / 2, centr.y - height / 2 }, size } */
UIKIT_STATIC_INLINE CGRect GMLRectCenterSize(CGPoint center, CGSize size) {
    return CGRectMake(center.x - size.width / 2.0, center.y - size.height / 2.0, size.width, size.height);
}

/** 计算 { { x + left, y + top }, { width - (left + right), height - (top + bottom) } } */
UIKIT_STATIC_INLINE CGRect GMLRectLessInset(CGRect rect, UIEdgeInsets inset) {
    return CGRectMake(CGRectGetMinX(rect) + inset.left, CGRectGetMinY(rect) + inset.top, GMLHorizontalValue(CGRectGetWidth(rect), inset), GMLVerticalValue(CGRectGetHeight(rect), inset));
}
/** 计算 { { x - left, y - top }, { width + (left + right), height + (top + bottom) } } */
UIKIT_STATIC_INLINE CGRect GMLRectAddInset(CGRect rect, UIEdgeInsets inset) {
    return CGRectMake(CGRectGetMinX(rect) - inset.left, CGRectGetMinY(rect) - inset.top, GMLMaxHorizontalValue(CGRectGetWidth(rect), inset),GMLMaxVerticalValue(CGRectGetHeight(rect), inset));
}

/** 计算 { { 0, 0}, { width, height } } */
UIKIT_STATIC_INLINE CGRect GMLRectBounds(CGRect frame) {
    return CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

/** 忽略顶部 计算 { { x + left, offsetY }, { width - (left + right), height - (offsetY + bottom) } } */
UIKIT_STATIC_INLINE CGRect GMLRectLessInsetExcludeTop(CGRect rect, UIEdgeInsets edgeInsets, CGFloat offsetY) {
    return CGRectMake(CGRectGetMinX(rect) + edgeInsets.left, CGRectGetMinY(rect) + offsetY, GMLHorizontalValue(CGRectGetWidth(rect), edgeInsets), CGRectGetHeight(rect) - (offsetY + edgeInsets.bottom));
}

/** 忽略底部 计算 { { x + left, y + top }, { width - (left + right), height} } */
UIKIT_STATIC_INLINE CGRect GMLRectLessInsetExcludeBottom(CGRect rect, UIEdgeInsets edgeInsets, CGFloat height) {
    return CGRectMake(CGRectGetMinX(rect) + edgeInsets.left, CGRectGetMinY(rect) + edgeInsets.top, GMLHorizontalValue(CGRectGetWidth(rect), edgeInsets), height);
}

/** 忽略垂直 计算 { { x + left, y + offsetY }, { width - (left + right), height } } */
UIKIT_STATIC_INLINE CGRect GMLRectLessInsetExcludeVertical(CGRect rect, UIEdgeInsets edgeInsets, CGFloat offsetY, CGFloat height) {
    return CGRectMake(CGRectGetMinX(rect) + edgeInsets.left, CGRectGetMinY(rect) + offsetY, GMLHorizontalValue(CGRectGetWidth(rect), edgeInsets), height);
}

/** 忽略右边 计算 { {x + left, y + top }, { width , height - (top + bottom) } } */
UIKIT_STATIC_INLINE CGRect GMLRectLessInsetExcludeRight(CGRect rect, UIEdgeInsets edgeInsets, CGFloat width) {
    return CGRectMake(CGRectGetMinX(rect) + edgeInsets.left, CGRectGetMinY(rect) + edgeInsets.top, width, GMLVerticalValue(CGRectGetHeight(rect), edgeInsets));
}

/** 忽略左边 计算 { { x + offsetX, y + top }, { width - (offsetX + right), height - (top + bottom) } }  */
UIKIT_STATIC_INLINE CGRect GMLRectLessInsetExcludeLeft(CGRect rect, UIEdgeInsets edgeInsets, CGFloat offsetX) {
    return CGRectMake(CGRectGetMinX(rect) + offsetX, CGRectGetMinY(rect) + edgeInsets.top, CGRectGetWidth(rect) - (offsetX + edgeInsets.right), GMLVerticalValue(CGRectGetHeight(rect), edgeInsets));
}

/** 忽略水平 计算 { { x + offsetX, y + top }, { width , height - (top + bottom) } */
UIKIT_STATIC_INLINE CGRect GMLRectLessInsetExcludeHorizontal(CGRect rect, UIEdgeInsets edgeInsets, CGFloat offsetX, CGFloat width) {
    return CGRectMake(CGRectGetMinX(rect) + offsetX, CGRectGetMinY(rect) + edgeInsets.top, width, GMLVerticalValue(CGRectGetHeight(rect), edgeInsets));
}

/** size 在可用区域(rect)内，垂直居中 */
UIKIT_STATIC_INLINE CGRect GMLRectVerticalCenterSize(CGRect rect, CGSize size) {
    return CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + (CGRectGetHeight(rect) - size.height) / 2, size.width, size.height);
}
/** size 在可用区域(rect)内，水平居中 */
UIKIT_STATIC_INLINE CGRect GMLRectHorizontalCenterSize(CGRect rect, CGSize size) {
    return CGRectMake(CGRectGetMinX(rect) + (CGRectGetWidth(rect) - size.width) / 2, CGRectGetMinY(rect), size.width, size.height);
}

#endif /* GMLRect_h */
