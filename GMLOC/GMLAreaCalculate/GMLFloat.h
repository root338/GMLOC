//
//  GMLFloat.h
//  GMLOCDemo
//
//  Created by apple on 2020/7/22.
//  Copyright © 2020 GML. All rights reserved.
//

#ifndef GMLFloat_h
#define GMLFloat_h

#import <UIKit/UIGeometry.h>

/** 计算 maxWith - (left + right) */
CG_INLINE CGFloat GMLHorizontalValue(CGFloat maxWidth, UIEdgeInsets edgeInsets) {
    return maxWidth - (edgeInsets.left + edgeInsets.right);
}

/** 计算 maxHeight - (top + bottom) */
UIKIT_STATIC_INLINE CGFloat GMLVerticalValue(CGFloat maxHeight, UIEdgeInsets edgeInsets) {
    return maxHeight - (edgeInsets.top + edgeInsets.bottom);
}

/** 计算 left + width + right */
UIKIT_STATIC_INLINE CGFloat GMLMaxHorizontalValue(CGFloat width, UIEdgeInsets edgeInsets) {
    return edgeInsets.left + width + edgeInsets.right;
}

/** 计算 top + height + bottom */
UIKIT_STATIC_INLINE CGFloat GMLMaxVerticalValue(CGFloat height, UIEdgeInsets edgeInsets) {
    return edgeInsets.top + height + edgeInsets.bottom;
}

/** 计算  */
UIKIT_STATIC_INLINE CGFloat GMLCenterValue(CGFloat width, CGFloat toWidth) {
    return (toWidth - width) / 2.0;
}

#endif /* GMLFloat_h */
