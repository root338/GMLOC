//
//  GMLMultiAngleView.m
//  QuickAskCommunity
//
//  Created by apple on 2020/5/26.
//  Copyright © 2020 ym. All rights reserved.
//

#import "GMLMultiAngleView.h"
#import "GMLMultiAngleLayer.h"
#import <GML_OC/CGGeometry+GMLAdd.h>

@implementation GMLMultiAngleView

+ (Class)layerClass {
    return GMLMultiAngleLayer.class;
}

- (instancetype)initWithContentView:(UIView *)contentView configure:(void (NS_NOESCAPE^)(id<GMLMultiAngleProtocol> _Nonnull))block {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _contentView = contentView;
        !block?: block(self.configure);
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return GMLSizeAddInsets([self.contentView sizeThatFits:GMLSizeAddInsets(size, _contentMarginInsets)], _contentMarginInsets);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentFrame = GMLRectLessInsets(self.bounds, _contentMarginInsets);
    self.contentView.frame = contentFrame;
    if (self.contentView.superview != self) [self addSubview:self.contentView];
    if (self.contentView.layer != self.layer.sublayers.lastObject) {
        [self.layer insertSublayer:self.contentView.layer atIndex:(unsigned)self.layer.sublayers.count];
    }
}

#pragma mark - Getter & Setter

- (id<GMLMultiAngleProtocol>)configure {
    if ([self.layer conformsToProtocol:@protocol(GMLMultiAngleProtocol)]) {
        return (id<GMLMultiAngleProtocol>)self.layer;
    }
    return nil;
}

@end
