//
//  GMLNavigationBarAppearance.m
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import "GMLNavigationBarAppearance.h"
#import <GML_OC/GMLDataCompareMacro.h>

@implementation GMLNavigationBarAppearance
- (BOOL)isEqual:(id)object {
    if (self == object) { return true; }
    if (object == nil || ![object isMemberOfClass:self.class]) { return false; }
    typeof(self) appearance = object;
    if (GMLEqualObjectAndContainNil(_backgroundColor, appearance.backgroundColor)
        && GMLEqualDictionaryAndContainNil(_titleTextAttributes, appearance.titleTextAttributes)
        && GMLEqualObjectAndContainNil(_tintColor, appearance.tintColor)
        && GMLEqualObjectAndContainNil(_backIndicatorImage, appearance.backIndicatorImage)
        && GMLEqualObjectAndContainNil(_backIndicatorTransitionMaskImage, appearance.backIndicatorTransitionMaskImage)) {
        return true;
    }
    return false;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [self copyWithZone:zone];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) appearance = [[self class] new];
    appearance.tintColor = self.tintColor;
    appearance.backgroundColor = self.backgroundColor;
    appearance.titleTextAttributes = self.titleTextAttributes;
    appearance.backIndicatorImage = self.backIndicatorImage;
    appearance.backIndicatorTransitionMaskImage = self.backIndicatorTransitionMaskImage;
    return appearance;
}

@end
