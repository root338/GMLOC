//
//  CGButtonDefinesHeader.h
//  GML-OC
//
//  Created by GML on 2022/8/3.
//

#ifndef CGButtonDefinesHeader_h
#define CGButtonDefinesHeader_h

/// 设置按钮标题与图片的对齐方式
typedef NS_ENUM(NSInteger, CGButtonStyle) {
    /// 水平对齐，标题居左
    CGButtonStyleHorizonalLeft,
    /// 水平对齐，标题居右
    CGButtonStyleHorizonalRight,
    /// 垂直对齐，标题居上
    CGButtonStyleVerticalTop,
    /// 垂直对齐，标题居下
    CGButtonStyleVerticalBottom,
};
/// 标题、图像的对齐方式
typedef NS_ENUM(NSInteger, CGButtonContentAlignment) {
    /// 居中
    CGButtonContentAlignmentCenter,
    /// 顶部对齐
    /// CGButtonStyleHorizonalLeft, CGButtonStyleHorizonalRight 下有效
    CGButtonContentAlignmentTop,
    /// 左对齐
    /// CGButtonStyleVerticalTop, CGButtonStyleVerticalBottom 下有效
    CGButtonContentAlignmentLeft,
    /// 底部对齐
    /// CGButtonStyleHorizonalLeft, CGButtonStyleHorizonalRight 下有效
    CGButtonContentAlignmentBottom,
    /// 右对齐
    /// CGButtonStyleVerticalTop, CGButtonStyleVerticalBottom 下有效
    CGButtonContentAlignmentRight,
};
/** 处理按钮当前内容时的方式，使用期间：计算按钮显示区域的时候 */
typedef NS_ENUM(NSInteger, CGButtonHandleCurrentContentType) {
    /** 空 */
    CGButtonHandleCurrentContentTypeNone,
    /** 默认的处理方法，当优先获取的值不存在时，获取次级内容项 */
    CGButtonHandleCurrentContentTypeDefalut,
};

#endif /* CGButtonDefinesHeader_h */
