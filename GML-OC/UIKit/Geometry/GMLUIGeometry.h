//
//  GMLUIGeometry.h
//  GML-OC
//
//  Created by GML on 2022/7/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

UIKIT_STATIC_INLINE CGRect GMLRectContentMode(CGRect totalRect, CGSize targetSize, UIViewContentMode mode) {
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
//UIKIT_STATIC_INLINE CGRect GMLRectContentMode(CGRect totalRect, CGSize targetSize, UIViewContentMode mode)
