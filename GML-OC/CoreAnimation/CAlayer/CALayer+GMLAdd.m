//
//  CALayer+GMLAdd.m
//  GML-OC
//
//  Created by GML on 2022/8/3.
//

#import "CALayer+GMLAdd.h"

#if __has_include(<UIKit/UIScreen.h>)
#import <UIKit/UIScreen.h>
#endif
@implementation CALayer (GMLAdd)

+ (void)disableDefaultAnimatedsWithBlock:(void (NS_NOESCAPE ^) (void))block {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    !block?: block();
    [CATransaction commit];
}

+ (instancetype)createLayerWithBackgroundColor:(CGColorRef)backgroundColor {
    CALayer *layer = [self layer];
#if __has_include(<UIKit/UIScreen.h>)
    layer.contentsScale = UIScreen.mainScreen.scale;
#endif
    layer.backgroundColor = backgroundColor;
    return layer;
}

@end


@implementation CAGradientLayer (GMLAdd)

+ (instancetype)createLineGradientWithType:(GMLLineGradientType)type startColor:(nullable CGColorRef)startColor endColor:(nullable CGColorRef)endColor {
    CAGradientLayer *layer = [self createLayerWithBackgroundColor:nil];
    [layer setupLineGradientWithType:type startColor:startColor endColor:endColor];
    return layer;
}

- (void)setupLineGradientWithType:(GMLLineGradientType)type startColor:(nullable CGColorRef)startColor endColor:(nullable CGColorRef)endColor {
    if (startColor == nil || endColor == nil) return;
    self.colors = @[
        (__bridge id)startColor,
        (__bridge id)endColor,
    ];
    self.locations = @[
        @0,
        @1,
    ];
    [self configurePathWithType:type];
}

- (void)setupLineGradientWithType:(GMLLineGradientType)type colors:(nonnull NSArray *)colors {
    [self validatorGradientColors:colors multColors:^(NSArray *colors) {
        self.colors = colors;
        [self configurePathWithType:type];
    } color:^(CGColorRef color) {
        self.backgroundColor = color;
        self.colors = nil;
    } empty:nil];
}

- (void)validatorGradientColors:(NSArray *)colors multColors:(void(^)(NSArray *collors))multColors color:(void(^)(CGColorRef color))color empty:(void(^)(void))empty {
    NSMutableArray *colorArr = NSMutableArray.array;
    for (id obj in colors) {
        id value = nil;
//        if ([obj isKindOfClass:[NSString class]]) {
//            value = (__bridge id)[[UIColor colorWithHexString:obj] CGColor];
//        }else
        if ([obj isKindOfClass:[UIColor class]]) {
            value = (__bridge id)[(UIColor *)obj CGColor];
        }else if (CFGetTypeID((__bridge CFTypeRef)obj) == CGColorGetTypeID()) {
            value = obj;
        }
        !value?: [colorArr addObject:value];
    }
    switch (colorArr.count) {
        case 0: !empty?: empty(); break;
        case 1: !color?: color((__bridge CGColorRef _Nullable)(colorArr.firstObject));
        default: !multColors?: multColors(colorArr); break;
    }
}

- (void)transformType:(GMLLineGradientType)type result:(void(^)(CGPoint start, CGPoint end))result {
    CGPoint startPoint  = CGPointZero;
    CGPoint endPoint = CGPointZero;
    if (type & GMLLineGradientTypeVertical) {
        endPoint.y = 1;
    }
    if (type & GMLLineGradientTypeHorizontal) {
        endPoint.x = 1;
    }
    !result?: result(startPoint, endPoint);
}
- (void)configurePathWithType:(GMLLineGradientType)type {
    [self transformType:type result:^(CGPoint start, CGPoint end) {
        self.startPoint = start;
        self.endPoint = end;
    }];
}

@end
