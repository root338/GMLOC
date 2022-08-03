//
//  GMLMultiAngleDefineHeader.h
//  QuickAskCommunity
//
//  Created by apple on 2020/6/29.
//  Copyright © 2020 ym. All rights reserved.
//

#ifndef GMLMultiAngleDefineHeader_h
#define GMLMultiAngleDefineHeader_h


typedef struct {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} YMMultiCornerRadius;

static inline YMMultiCornerRadius YMMultiCornerRadiusMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight) {
    YMMultiCornerRadius radius;
    radius.topLeft = topLeft;
    radius.topRight = topRight;
    radius.bottomLeft = bottomLeft;
    radius.bottomRight = bottomRight;
    return radius;
}
static inline YMMultiCornerRadius YMMultiCornerRadiusValue(CGFloat value) {
    return YMMultiCornerRadiusMake(value, value, value, value);
}
static inline BOOL YMMultiCornerRadiusEqualToValue(YMMultiCornerRadius v1, YMMultiCornerRadius v2) {
    return v1.topLeft == v2.topLeft
    && v1.topRight == v2.topRight
    && v1.bottomLeft == v2.bottomLeft
    && v1.bottomRight == v2.bottomRight;
}

#endif /* GMLMultiAngleDefineHeader_h */
