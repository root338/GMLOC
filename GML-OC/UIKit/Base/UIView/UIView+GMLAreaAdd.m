//
//  UIView+GMLAreaAdd.m
//  GML-OC
//
//  Created by GML on 2022/8/3.
//

#import "UIView+GMLAreaAdd.h"

@implementation UIView (GMLAreaAdd)

#pragma mark - 坐标设置
- (CGFloat)xOrigin { return self.origin.x; }
- (void)setXOrigin:(CGFloat)xOrigin {
    CGRect frame = self.frame;
    if (frame.origin.x != xOrigin) {
        frame.origin.x = xOrigin;
        self.frame = frame;
    }
}

- (CGFloat)yOrigin { return self.origin.y; }
- (void)setYOrigin:(CGFloat)yOrigin {
    CGRect frame = self.frame;
    if (frame.origin.y != yOrigin) {
        frame.origin.y = yOrigin;
        self.frame = frame;
    }
}

- (CGPoint)origin { return self.frame.origin; }

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    if (!CGPointEqualToPoint(origin, frame.origin)) {
        frame.origin = origin;
        self.frame = frame;
    }
}

- (CGFloat)xCenter { return self.center.x; }
- (void)setXCenter:(CGFloat)xCenter {
    CGPoint center = self.center;
    if (center.x != xCenter) {
        center.x = xCenter;
        self.center = center;
    }
}

- (CGFloat)yCenter { return self.center.y; }

- (void)setYCenter:(CGFloat)yCenter {
    CGPoint center = self.center;
    if (center.y != yCenter) {
        center.y = yCenter;
        self.center = center;
    }
}

#pragma mark - 大小设置
- (CGFloat)width { return self.size.width; }

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    if (frame.size.width != width) {
        frame.size.width = width;
        self.frame = frame;
    }
}

- (CGFloat)height { return self.size.height; }

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    if (frame.size.height != height) {
        frame.size.height = height;
        self.frame = frame;
    }
}

- (CGSize)size { return self.frame.size; }

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    if (!CGSizeEqualToSize(size, frame.size)) {
        frame.size = size;
        self.frame = frame;
    }
}

#pragma mark - 显示区域获取
- (CGFloat)minX { return CGRectGetMinX(self.frame); }

- (CGFloat)minY { return CGRectGetMinY(self.frame); }

- (CGFloat)midX { return CGRectGetMidX(self.frame); }

- (CGFloat)midY { return CGRectGetMidY(self.frame); }

- (CGFloat)maxX { return CGRectGetMaxX(self.frame); }

- (CGFloat)maxY { return CGRectGetMaxY(self.frame); }

@end
