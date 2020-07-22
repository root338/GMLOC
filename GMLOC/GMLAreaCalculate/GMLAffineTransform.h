//
//  GMLAffineTransform.h
//  GMLOCDemo
//
//  Created by apple on 2020/7/22.
//  Copyright © 2020 GML. All rights reserved.
//

#ifndef GMLAffineTransform_h
#define GMLAffineTransform_h

#import "GMLAreaCalculateDefine.h"

/** 计算以任意点旋转的CGAffineTransform值 */
UIKIT_STATIC_INLINE CGAffineTransform GMLAffineTransformRotate(CGPoint center, CGPoint rotateVertex, float angle) {
    
    //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    CGFloat x = rotateVertex.x - center.x;
    
    //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
    CGFloat y = rotateVertex.y - center.y;
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(x, y);
    trans   = CGAffineTransformRotate(trans, GMLRadianForAngle(angle));
    trans   = CGAffineTransformTranslate(trans, -x, -y);
    
    return trans;
}

#endif /* GMLAffineTransform_h */
