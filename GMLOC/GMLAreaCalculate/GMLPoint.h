//
//  GMLPoint.h
//  GMLOCDemo
//
//  Created by apple on 2020/7/22.
//  Copyright © 2020 GML. All rights reserved.
//

#ifndef GMLPoint_h
#define GMLPoint_h

#import "GMLFloat.h"

UIKIT_STATIC_INLINE BOOL GMLPointIsNAN(CGPoint p1) {
    return isnan(p1.x) || isnan(p1.y);
}
/** 计算 { p1.x + x, p1.y + y } */
UIKIT_STATIC_INLINE CGPoint GMLPointOffsetValue(CGPoint p1, CGFloat x, CGFloat y) {
    return CGPointMake(p1.x + x, p1.y + y);
}
/** 计算 { p1.x + p2.x, p1.y + p2.y } */
UIKIT_STATIC_INLINE CGPoint GMLPointOffsetPoint(CGPoint p1, CGPoint p2) {
    return GMLPointOffsetValue(p1, p2.x, p2.y);
}
/** 获取 s1 的中心点 */
UIKIT_STATIC_INLINE CGPoint GMLSizeCenter(CGSize s1) {
    return CGPointMake(s1.width / 2.0, s1.height / 2.0);
}
/** s 在 toSize 中的中心坐标CGRect */
UIKIT_STATIC_INLINE CGRect GMLSizeCenterRectToSize(CGSize s, CGSize toSize) {
    return CGRectMake(GMLCenterValue(s.width, toSize.width), GMLCenterValue(s.height, toSize.height), s.width, s.height);
}
/** 两个坐标的中点 {(x1 + x2) / 2.0, (y1 + y2) / 2.0} */
UIKIT_STATIC_INLINE CGPoint GMLMidPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
}
/// {MIN(p1.x, p2.x), MIN(p1.y, p2.y)}
UIKIT_STATIC_INLINE CGPoint GMLMinPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake(MIN(p1.x, p2.x), MIN(p1.y, p2.y));
}
// {MAX(p1.x, p2.x), MAX(p1.y, p2.y)}
UIKIT_STATIC_INLINE CGPoint GMLMaxPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake(MAX(p1.x, p2.x), MAX(p1.y, p2.y));
}

#endif /* GMLPoint_h */
