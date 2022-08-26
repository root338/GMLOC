//
//  GMLNavigationBarAppearanceManager.m
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import "GMLNavigationBarAppearanceManager.h"
#import "GMLNavigationBarAppearance.h"
#import "GMLNavigationBarAppearanceItem.h"
#import "GMLNavigationBarAppearanceProtocol.h"

#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationBarAppearance.h>

typedef struct {
    unsigned int appearanceDidChange: 1;
    unsigned int createMutableNavigationBarAppearance: 1;
} _GMLNavigationBarAppearanceManagerDelegateFlag;

@interface GMLNavigationBarAppearanceManager ()
{
    id<GMLNavigationBarAppearanceProtocol> _lastNilDefaultAppearance;
    id<GMLNavigationBarAppearanceProtocol> _currentUsingAppearance;
}
@property (nonatomic, assign) BOOL disableUpdateCurrentDefaultAppearance;
@property (nonatomic, strong) NSMutableArray *appearanceItems;
@property (nonatomic, assign) _GMLNavigationBarAppearanceManagerDelegateFlag delegateFlag;
@end

@implementation GMLNavigationBarAppearanceManager
@synthesize defaultAppearance = _defaultAppearance;

- (void)pushNilAppearance {
    [self.appearanceItems addObject:NSNull.null];
}
- (void)push:(GMLNavigationBarAppearanceItem *)item {
    [self.appearanceItems addObject:item];
    [self _updateCurrentUsingAppearance];
}
- (void)pop {
    [self.appearanceItems removeLastObject];
    [self _updateCurrentUsingAppearance];
}
- (void)removeAllAppearance {
    [self.appearanceItems removeAllObjects];
    [self _updateCurrentUsingAppearance];
}
- (void)removeAppearancesInRange:(NSRange)range {
    if (range.location == NSNotFound
        || range.length == 0
        || (range.location + range.length > _appearanceItems.count)
        ) { return; }
    [_appearanceItems removeObjectsInRange:range];
    [self _updateCurrentUsingAppearance];
}
- (void)updateAppearance:(void (^)(GMLNavigationBarAppearanceManager * _Nonnull))block {
    BOOL isDisableUpdate = _disableUpdateCurrentDefaultAppearance;
    if (!isDisableUpdate) _disableUpdateCurrentDefaultAppearance = true;
    block(self);
    if (!isDisableUpdate) {
        _disableUpdateCurrentDefaultAppearance = false;
        [self _updateCurrentUsingAppearance];
    }
}

- (id<GMLNavigationBarAppearanceProtocol>)lastNilDefaultAppearance {
    return [(_lastNilDefaultAppearance?: _defaultAppearance) copyWithZone:nil];
}

- (id<GMLNavigationBarAppearanceProtocol>)currentUsingAppearance {
    return [(_currentUsingAppearance?: _defaultAppearance) copyWithZone:nil];
}

- (UINavigationBarAppearance *)currentNavigationBarAppearance API_AVAILABLE(ios(13.0)) {
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [self applyToNavigationBarAppearance:appearance];
    return appearance;
}

- (id<GMLMutableNavigationBarAppearanceProtocol>)appearanceWithNavigationBar:(UINavigationBar *)navigationBar {
    id<GMLMutableNavigationBarAppearanceProtocol> appearance = nil;
    if (@available(iOS 13.0, *)) {
        appearance = [self appearanceWithNavigationBarAppearance:navigationBar.standardAppearance];
    } else {
        appearance = [self _createMutableNavigationBarAppearance];
        appearance.backIndicatorImage = navigationBar.backIndicatorImage;
        appearance.backIndicatorTransitionMaskImage = navigationBar.backIndicatorTransitionMaskImage;
        appearance.backgroundColor = navigationBar.barTintColor;
        appearance.titleTextAttributes = navigationBar.titleTextAttributes;
    }
    appearance.tintColor = navigationBar.tintColor;
    return appearance;
}
- (id<GMLMutableNavigationBarAppearanceProtocol>)appearanceWithNavigationBarAppearance:(UINavigationBarAppearance *)barAppearance API_AVAILABLE(ios(13.0)) {
    
    id<GMLMutableNavigationBarAppearanceProtocol>appearance = [self _createMutableNavigationBarAppearance];
    appearance.backgroundColor = barAppearance.backgroundColor;
    appearance.titleTextAttributes = barAppearance.titleTextAttributes;
    appearance.backIndicatorImage = barAppearance.backIndicatorImage;
    appearance.backIndicatorTransitionMaskImage = barAppearance.backIndicatorTransitionMaskImage;
    return appearance;
}

- (void)applyTo:(UINavigationBar *)navigationBar {
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] initWithBarAppearance:navigationBar.standardAppearance];
        [self applyToNavigationBarAppearance:appearance];
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = appearance;
        navigationBar.compactAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            navigationBar.compactScrollEdgeAppearance = appearance;
        }
    }else {
        id<GMLNavigationBarAppearanceProtocol> appearance = _currentUsingAppearance;
        navigationBar.barTintColor = appearance.backgroundColor;
        navigationBar.titleTextAttributes = appearance.titleTextAttributes;
        navigationBar.backIndicatorImage = appearance.backIndicatorImage;
        navigationBar.backIndicatorTransitionMaskImage = appearance.backIndicatorTransitionMaskImage;
    }
    navigationBar.tintColor = _currentUsingAppearance.tintColor;
}

- (void)applyToNavigationBarAppearance:(UINavigationBarAppearance *)barAppearance API_AVAILABLE(ios(13.0)) {
    id<GMLNavigationBarAppearanceProtocol>appearance = _currentUsingAppearance;
    barAppearance.backgroundColor = appearance.backgroundColor;
    barAppearance.titleTextAttributes = appearance.titleTextAttributes;
    [barAppearance setBackIndicatorImage:appearance.backIndicatorImage transitionMaskImage:appearance.backIndicatorTransitionMaskImage];
}

#pragma mark - Private
- (id<GMLMutableNavigationBarAppearanceProtocol>)_createMutableNavigationBarAppearance {
    if (_delegateFlag.createMutableNavigationBarAppearance) {
        return [_delegate createMutableNavigationBarAppearanceWithMangaer:self];
    }else {
        return [GMLNavigationBarAppearance new];
    }
}
- (id<GMLNavigationBarAppearanceProtocol>)_searchLastNilDefaultAppearance {
    __block id<GMLNavigationBarAppearanceProtocol> appearance = nil;
    [self.appearanceItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:GMLNavigationBarAppearanceItem.class]) return;
        GMLNavigationBarAppearanceItem *item = (GMLNavigationBarAppearanceItem *)obj;
        if (item.effectiveType != GMLNavigationBarAppearanceAfterOneselfEffective) return;
        appearance = item.appearance;
        *stop = true;
    }];
    return appearance ?: _defaultAppearance;
}
- (id<GMLNavigationBarAppearanceProtocol>)_searchCurrentUsingAppearance {
    __block id<GMLNavigationBarAppearanceProtocol> appearance = nil;
    [self.appearanceItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:GMLNavigationBarAppearanceItem.class]) return;
        GMLNavigationBarAppearanceItem *item = (GMLNavigationBarAppearanceItem *)obj;
        appearance = item.appearance;
        *stop = true;
    }];
    return appearance?: _defaultAppearance;
}
- (void)_updateCurrentUsingAppearance {
    if (_disableUpdateCurrentDefaultAppearance) { return; }
    id<GMLNavigationBarAppearanceProtocol>appearance = [self _searchCurrentUsingAppearance];
    if ([_currentUsingAppearance isEqual:appearance]) { return; }
    _currentUsingAppearance = appearance;
    if (_delegateFlag.appearanceDidChange) {
        [_delegate navigationBarCurrentUsingAppearanceDidChangeManager:self];
    }
}

#pragma mark - Getter & Setter
- (void)setDelegate:(id<GMLNavigationBarAppearanceManagerDelegate>)delegate {
    if (_delegate == delegate) return;
    _delegate = delegate;
    _GMLNavigationBarAppearanceManagerDelegateFlag flag;
    flag.appearanceDidChange = [delegate respondsToSelector:@selector(navigationBarCurrentUsingAppearanceDidChangeManager:)];
    flag.createMutableNavigationBarAppearance = [delegate respondsToSelector:@selector(createMutableNavigationBarAppearanceWithMangaer:)];
    self.delegateFlag = flag;
}

- (void)setDefaultAppearance:(id<GMLNavigationBarAppearanceProtocol>)defaultAppearance {
    if ([_defaultAppearance isEqual:defaultAppearance]) { return; }
    _defaultAppearance = [defaultAppearance copyWithZone:nil];
    [self _updateCurrentUsingAppearance];
}

- (NSMutableArray *)appearanceItems {
    if (!_appearanceItems) {
        _appearanceItems = [NSMutableArray array];
    }
    return _appearanceItems;
}

@end
