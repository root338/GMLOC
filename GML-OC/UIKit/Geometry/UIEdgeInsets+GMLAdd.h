//
//  UIEdgeInsets+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/8/12.
//

#ifndef UIEdgeInsets_GMLAdd_h
#define UIEdgeInsets_GMLAdd_h

/// 当UIEdgeInsets的四边间距相等使用
UIKIT_STATIC_INLINE UIEdgeInsets GMLEdgeInsetsValue(CGFloat value) {
    return UIEdgeInsetsMake(value, value, value, value);
}

/** 设置顶部数值，其他为0 */
UIKIT_STATIC_INLINE UIEdgeInsets GMLEdgeInsetsTop(CGFloat topValue) {
    return UIEdgeInsetsMake(topValue, 0, 0, 0);
}

/** 设置左边数值，其他为0 */
UIKIT_STATIC_INLINE UIEdgeInsets GMLEdgeInsetsLeft(CGFloat leftValue) {
    return UIEdgeInsetsMake(0, leftValue, 0, 0);
}

/** 设置底部数值，其他为0 */
UIKIT_STATIC_INLINE UIEdgeInsets GMLEdgeInsetsBottom(CGFloat bottomValue) {
    return UIEdgeInsetsMake(0, 0, bottomValue, 0);
}

/** 设置右边数值，其他为0 */
UIKIT_STATIC_INLINE UIEdgeInsets GMLEdgeInsetsRight(CGFloat rightValue) {
    return UIEdgeInsetsMake(0, 0, 0, rightValue);
}

/** 设置left、right值 其他为0 */
UIKIT_STATIC_INLINE UIEdgeInsets GMLEdgeInsetsHorizontal(CGFloat horizontalValue) {
    return UIEdgeInsetsMake(0, horizontalValue, 0, horizontalValue);
}

/** 设置left、right值 其他为0 */
UIKIT_STATIC_INLINE UIEdgeInsets GMLEdgeInsetsVertical(CGFloat verticalValue) {
    return UIEdgeInsetsMake(verticalValue, 0, verticalValue, 0);
}

/** 计算 left + right */
UIKIT_STATIC_INLINE CGFloat GMLEdgeInsetsTotalHorizontal(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/** 计算 top + bottom */
UIKIT_STATIC_INLINE CGFloat GMLEdgeInsetsTotalVertical(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

UIKIT_STATIC_INLINE UIEdgeInsets GMLEdgeInsetsAdd(UIEdgeInsets insets1, UIEdgeInsets insets2) {
    return UIEdgeInsetsMake(insets1.top + insets2.top, insets1.left + insets2.left, insets1.bottom + insets2.bottom, insets1.right + insets2.right);
}



#endif /* UIEdgeInsets_GMLAdd_h */
