//
//  GMLNavigationControllerViewStateManager.m
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import "GMLNavigationControllerViewStateManager.h"
#import "UIViewController+GMLViewStateAdd.h"

typedef struct {
    unsigned int willAppear: 1;
    unsigned int didAppear: 1;
    unsigned int willDisappear: 1;
    unsigned int didDisappear: 1;
} _GMLNavigationStateManagerDelegateFlag;

@interface GMLNavigationControllerViewStateManager ()
{
    
}
@property (nonatomic, assign) _GMLNavigationStateManagerDelegateFlag delegateFlag;
@end

@implementation GMLNavigationControllerViewStateManager

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self _addAppearViewController:viewController];
    [self _addDisappearViewController:self.navigationController.viewControllers.lastObject];
}
- (void)popViewControllerAnimated:(BOOL)animated {
    NSArray *vcs = self.navigationController.viewControllers;
    NSUInteger count = vcs.count;
    if (count <= 1) return;
    [self _addAppearViewController:vcs[count - 2]];
    [self _addDisappearViewController:vcs[count - 1]];
}
- (void)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *vcs = self.navigationController.viewControllers;
    NSUInteger count = vcs.count;
    if (count <= 1) return;
    [self _addAppearViewController:vcs.firstObject];
    [self _addDisappearViewController:vcs.lastObject];
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [self _addAppearViewController:viewControllers.lastObject];
    [self _addDisappearViewController:self.navigationController.viewControllers.lastObject];
}

#pragma mark - Private
- (void)_addAppearViewController:(UIViewController *)viewController {
    __weak typeof(self) weakself = self;
    __weak UIViewController *weakVC = viewController;
    if (_delegateFlag.willAppear) {
        [viewController gml_addViewWillAppearBlock:^(id<GMLViewControllerViewStateToken> token, BOOL animated) {
            if (weakself == nil || weakVC == nil) return;
            __strong typeof(self) strongSelf = self;
            __strong UIViewController *strongVC = weakVC;
            if (strongSelf.delegateFlag.willAppear) {
                [strongSelf.delegate manager:strongSelf willAppearViewController:strongVC];
            }
            [token cancel];
        }];
    }
    if (_delegateFlag.didAppear) {
        [viewController gml_addViewDidAppearBlock:^(id<GMLViewControllerViewStateToken> token, BOOL animated) {
            if (weakself == nil || weakVC == nil) return;
            __strong typeof(self) strongSelf = self;
            __strong UIViewController *strongVC = weakVC;
            if (strongSelf.delegateFlag.didAppear) {
                [strongSelf.delegate manager:strongSelf didAppearViewController:strongVC];
            }
            [token cancel];
        }];
    }
}
- (void)_addDisappearViewController:(UIViewController *)viewController {
    __weak typeof(self) weakself = self;
    __weak UIViewController *weakVC = viewController;
    if (_delegateFlag.willDisappear) {
        [viewController gml_addViewWillDisappearBlock:^(id<GMLViewControllerViewStateToken> token, BOOL animated) {
            if (weakself == nil || weakVC == nil) return;
            __strong typeof(self) strongSelf = self;
            __strong UIViewController *strongVC = weakVC;
            if (strongSelf.delegateFlag.willDisappear) {
                [strongSelf.delegate manager:strongSelf willDisappearViewController:strongVC];
            }
            [token cancel];
        }];
    }
    if (_delegateFlag.didDisappear) {
        [viewController gml_addViewDidDisappearBlock:^(id<GMLViewControllerViewStateToken> token, BOOL animated) {
            if (weakself == nil || weakVC == nil) return;
            __strong typeof(self) strongSelf = self;
            __strong UIViewController *strongVC = weakVC;
            if (strongSelf.delegateFlag.didDisappear) {
                [strongSelf.delegate manager:strongSelf didDisappearViewController:strongVC];
            }
            [token cancel];
        }];
    }
}

#pragma mark - Getter & Setter
- (void)setDelegate:(id<GMLNavigationStateManagerDelegate>)delegate {
    if (_delegate == delegate) return;
    _delegate = delegate;
    _GMLNavigationStateManagerDelegateFlag delegateFlag;
    delegateFlag.willAppear = [delegate respondsToSelector:@selector(manager:willAppearViewController:)];
    delegateFlag.didAppear = [delegate respondsToSelector:@selector(manager:didAppearViewController:)];
    delegateFlag.willDisappear = [delegate respondsToSelector:@selector(manager:willDisappearViewController:)];
    delegateFlag.didDisappear = [delegate respondsToSelector:@selector(manager:didDisappearViewController:)];
    _delegateFlag = delegateFlag;
}

@end
