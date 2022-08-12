//
//  CGAffineTransform+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/8/12.
//

#ifndef CGAffineTransform_GMLAdd_h
#define CGAffineTransform_GMLAdd_h

#import <GML_OC/GMLRadianAngle.h>

/** 计算以任意点旋转的CGAffineTransform值 */
CG_INLINE CGAffineTransform GMLAffineTransformRotate(CGPoint center, CGPoint rotateVertex, float angle) {
    
    //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    CGFloat x = rotateVertex.x - center.x;
    
    //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
    CGFloat y = rotateVertex.y - center.y;
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(x, y);
    trans   = CGAffineTransformRotate(trans, GMLAngleToRadian(angle));
    trans   = CGAffineTransformTranslate(trans, -x, -y);
    
    return trans;
}


#endif /* CGAffineTransform_GMLAdd_h */
