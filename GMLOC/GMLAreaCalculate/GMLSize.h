//
//  GMLSize.h
//  GMLOCDemo
//
//  Created by apple on 2020/7/22.
//  Copyright © 2020 GML. All rights reserved.
//

#ifndef GMLSize_h
#define GMLSize_h

#import "GMLFloat.h"

/** 计算 { maxWith - (left + right), maxHeight - (top + bottom) } */
UIKIT_STATIC_INLINE CGSize GMLSizeLessInset(CGSize size, UIEdgeInsets inset) {
    return CGSizeMake(GMLHorizontalValue(size.width, inset), GMLVerticalValue(size.height, inset));
}
/** 计算 { left + width + right, top + height + bottom } */
UIKIT_STATIC_INLINE CGSize GMLSizeAddInset(CGSize size, UIEdgeInsets inset) {
    return CGSizeMake(GMLMaxHorizontalValue(size.width, inset), GMLMaxVerticalValue(size.height, inset));
}
/** 获取两个CGSize值中更小的width和height */
UIKIT_STATIC_INLINE CGSize GMLMinSize(CGSize s1, CGSize s2) {
    return CGSizeMake(MIN(s1.width, s2.width), MIN(s1.height, s2.height));
}
/** 获取两个CGSize值中更大的width和height */
UIKIT_STATIC_INLINE CGSize GMLMaxSize(CGSize s1, CGSize s2) {
    return CGSizeMake(MAX(s1.width, s2.width), MAX(s1.height, s2.height));
}
/// {s1.width + s2.width, s1.height + s2.height}
UIKIT_STATIC_INLINE CGSize GMLSizeAddSize(CGSize s1, CGSize s2) {
    return CGSizeMake(s1.width + s2.width, s1.height + s2.height);
}
/// {s1.width + width, s1.height + height}
UIKIT_STATIC_INLINE CGSize GMLSizeAddValue(CGSize s1, CGFloat width, CGFloat height) {
    return CGSizeMake(s1.width + width, s1.height + height);
}

#endif /* GMLSize_h */
