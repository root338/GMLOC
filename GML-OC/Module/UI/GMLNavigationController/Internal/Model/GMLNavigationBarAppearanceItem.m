//
//  GMLNavigationBarAppearanceItem.m
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import "GMLNavigationBarAppearanceItem.h"
#import "GMLNavigationBarAppearance.h"

@interface GMLNavigationBarAppearanceItem ()
@property (nonatomic, copy, readwrite) id<GMLNavigationBarAppearanceProtocol> appearance;
@property (nonatomic, assign, readwrite) GMLNavigationBarAppearanceEffectivePeriod effectiveType;
@end

@implementation GMLNavigationBarAppearanceItem

- (instancetype)initWithAppearance:(id<GMLNavigationBarAppearanceProtocol>)appearance effectiveType:(GMLNavigationBarAppearanceEffectivePeriod)effectiveType {
    self = [super init];
    if (self) {
        _appearance = [appearance copyWithZone:nil];
        _effectiveType = effectiveType;
    }
    return self;
}
- (id)copyWithZone:(nullable NSZone *)zone {
    GMLNavigationBarAppearanceItem *item = [[self class] new];
    item.appearance = [self.appearance copyWithZone:nil];
    item.effectiveType = self.effectiveType;
    return item;
}
@end
