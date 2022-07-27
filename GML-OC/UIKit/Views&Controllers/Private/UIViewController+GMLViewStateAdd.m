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

@interface UIViewController (__GMLViewStateAdd)
@property (nonatomic, strong) NSMutableArray<GMLViewControllerViewStateItem *> *viewStateItems_gml;
@property (nonatomic, assign) GMLViewControllerViewState didAddViewStateFlag_gml;
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

- (id<GMLViewControllerViewStateToken>)gml_addViewState:(GMLViewControllerViewState)state callback:(GMLViewControllerViewStateCallback)callback {
    GMLViewControllerViewStateItem *item = [[GMLViewControllerViewStateItem alloc] initWithState:state block:callback];
    if (state == 0) return item;
    NSMutableArray *items = self.viewStateItems_gml;
    if (items == nil) {
        items = NSMutableArray.array;
        self.viewStateItems_gml = items;
    }
    [items addObject:item];
    
    {// 更新已经添加状态集
        GMLViewControllerViewState oldDidAddState = self.didAddViewStateFlag_gml;
        GMLViewControllerViewState didAddState = oldDidAddState | state;
        if (didAddState != oldDidAddState) {
            self.didAddViewStateFlag_gml = didAddState;
        }
    }
    
    return item;
}
- (void)gml_removeViewStateToken:(id<GMLViewControllerViewStateToken>)token {
    [self.viewStateItems_gml removeObject:token];
}

- (void)_gml_viewWillAppear:(BOOL)animated {
    if (self.didAddViewStateFlag_gml & GMLViewControllerViewStateAppear) {
        [self _forwardViewState:GMLViewControllerViewStateWillAppear isAnimated:animated];
    }
    [self _gml_viewWillAppear:animated];
}
- (void)_gml_viewDidAppear:(BOOL)animated {
    if (self.didAddViewStateFlag_gml & GMLViewControllerViewStateDidAppear) {
        [self _forwardViewState:GMLViewControllerViewStateDidAppear isAnimated:animated];
    }
    [self _gml_viewDidAppear:animated];
}
- (void)_gml_viewWillDisappear:(BOOL)animated {
    if (self.didAddViewStateFlag_gml & GMLViewControllerViewStateWillDisappear) {
        [self _forwardViewState:GMLViewControllerViewStateWillDisappear isAnimated:animated];
    }
    [self _gml_viewWillDisappear:animated];
}
- (void)_gml_viewDidDisappear:(BOOL)animated {
    if (self.didAddViewStateFlag_gml & GMLViewControllerViewStateDidDisappear) {
        [self _forwardViewState:GMLViewControllerViewStateDidDisappear isAnimated:animated];
    }
    [self _gml_viewDidDisappear:animated];
}

- (void)_forwardViewState:(GMLViewControllerViewState)viewState isAnimated:(BOOL)isAnimated {
    // 为了在列表遍历中执行删除操作时导致出错
    [[self.viewStateItems_gml copy] enumerateObjectsUsingBlock:^(GMLViewControllerViewStateItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state & viewState) {
            obj.block(viewState, isAnimated);
        }
    }];
}

@end

@implementation UIViewController (__GMLViewStateAdd)

- (void)setViewStateItems_gml:(NSMutableArray<GMLViewControllerViewStateItem *> *)items {
    objc_setAssociatedObject(self, @selector(viewStateItems_gml), items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray<GMLViewControllerViewStateItem *> *)viewStateItems_gml {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDidAddViewStateFlag_gml:(GMLViewControllerViewState)flag {
    objc_setAssociatedObject(self, @selector(didAddViewStateFlag_gml), @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (GMLViewControllerViewState)didAddViewStateFlag_gml {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

@end
