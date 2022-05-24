//
//  UIViewController+GMLViewStateAdd.m
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import "UIViewController+GMLViewStateAdd.h"
#import "Runtime+GMLAdd.h"
#import "GMLViewControllerViewStateItem.h"

#import <objc/runtime.h>

#define __NaviViewStateContainer NSHashTable<GMLViewControllerViewStateItem *>
#define __AddViewStateBlockCode(container) \
GMLViewControllerViewStateItem *token = [[GMLViewControllerViewStateItem alloc] initWithBlock:block]; \
if (container == nil) { \
    container = [NSHashTable weakObjectsHashTable]; \
} \
[container addObject:token]; \
return token;

@interface UIViewController (__GMLViewStateAdd)
@property (nonatomic, strong) __NaviViewStateContainer *viewWillAppearItems_gml;
@property (nonatomic, strong) __NaviViewStateContainer *viewDidAppearItems_gml;
@property (nonatomic, strong) __NaviViewStateContainer *viewWillDisappearItems_gml;
@property (nonatomic, strong) __NaviViewStateContainer *viewDidDisappearItems_gml;
@end

@implementation UIViewController (GMLViewStateAdd)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzledInstanceMethodAtSelector:@selector(viewWillAppear:) withInstanceMethodAtSelector:@selector(_gml_viewWillAppear:)];
        [self swizzledInstanceMethodAtSelector:@selector(viewDidAppear:) withInstanceMethodAtSelector:@selector(_gml_viewDidAppear:)];
        [self swizzledInstanceMethodAtSelector:@selector(viewWillDisappear:) withInstanceMethodAtSelector:@selector(_gml_viewWillDisappear:)];
        [self swizzledInstanceMethodAtSelector:@selector(viewDidDisappear:) withInstanceMethodAtSelector:@selector(_gml_viewDidDisappear:)];
    });
}

- (id<GMLViewControllerViewStateToken>)gml_addViewWillAppearBlock:(GMLViewShowStateBlock)block {
    __AddViewStateBlockCode(self.viewWillAppearItems_gml)
}
- (id<GMLViewControllerViewStateToken>)gml_addViewDidAppearBlock:(GMLViewShowStateBlock)block {
    __AddViewStateBlockCode(self.viewDidAppearItems_gml)
}
- (id<GMLViewControllerViewStateToken>)gml_addViewWillDisappearBlock:(GMLViewShowStateBlock)block {
    __AddViewStateBlockCode(self.viewWillDisappearItems_gml)
}
- (id<GMLViewControllerViewStateToken>)gml_addViewDidDisappearBlock:(GMLViewShowStateBlock)block {
    __AddViewStateBlockCode(self.viewDidDisappearItems_gml)
}

- (void)_gml_viewWillAppear:(BOOL)animated {
    [self _forwardViewStateBlockWithContainer:self.viewWillAppearItems_gml isAnimated:animated];
    [self _gml_viewWillAppear:animated];
}
- (void)_gml_viewDidAppear:(BOOL)animated {
    [self _forwardViewStateBlockWithContainer:self.viewDidAppearItems_gml isAnimated:animated];
    [self _gml_viewDidAppear:animated];
}
- (void)_gml_viewWillDisappear:(BOOL)animated {
    [self _forwardViewStateBlockWithContainer:self.viewWillDisappearItems_gml isAnimated:animated];
    [self _gml_viewWillDisappear:animated];
}
- (void)_gml_viewDidDisappear:(BOOL)animated {
    [self _forwardViewStateBlockWithContainer:self.viewDidDisappearItems_gml isAnimated:animated];
    [self _gml_viewDidDisappear:animated];
}

- (void)_forwardViewStateBlockWithContainer:(__NaviViewStateContainer *)container isAnimated: (BOOL)isAnimated {
    NSEnumerator<GMLViewControllerViewStateItem *> *objectEnumerator = container.objectEnumerator;
    GMLViewControllerViewStateItem *item = nil;
    while ((item = objectEnumerator.nextObject) != nil) {
        item.block(item, isAnimated);
    }
}

@end

@implementation UIViewController (__GMLViewStateAdd)

- (void)setViewWillAppearItems_gml:(__NaviViewStateContainer *)items {
    objc_setAssociatedObject(self, @selector(viewWillAppearItems_gml), items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (__NaviViewStateContainer *)viewWillAppearItems_gml {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setViewDidAppearItems_gml:(NSHashTable<GMLViewControllerViewStateItem *> *)items {
    objc_setAssociatedObject(self, @selector(viewDidAppearItems_gml), items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (__NaviViewStateContainer *)viewDidAppearItems_gml {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setViewWillDisappearItems_gml:(__NaviViewStateContainer *)items {
    objc_setAssociatedObject(self, @selector(viewWillDisappearItems_gml), items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (__NaviViewStateContainer *)viewWillDisappearItems_gml {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setViewDidDisappearItems_gml:(__NaviViewStateContainer *)items {
    objc_setAssociatedObject(self, @selector(viewDidDisappearItems_gml), items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (__NaviViewStateContainer *)viewDidDisappearItems_gml {
    return objc_getAssociatedObject(self, _cmd);
}

@end
