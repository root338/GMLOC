//
//  GMLConfigureNavigationControllerManager.m
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import "GMLConfigureNavigationControllerManager.h"
#import "GMLNavigationBarAppearanceItem.h"
#import "UIViewController+GMLViewStateAdd.h"
#import "GMLViewControllerViewStateDefine.h"
#import "GMLNavigationBarAppearanceManager.h"
#import "GMLConfigureNavigationControllerProtocol.h"

#import <UIKit/UINavigationController.h>

@interface GMLConfigureNavigationControllerManager ()<GMLNavigationBarAppearanceManagerDelegate>
@property (nonatomic, strong) GMLNavigationBarAppearanceManager *appearanceManager;
@property (nonatomic, assign, readwrite) BOOL isNeedUpdate;
@end

@implementation GMLConfigureNavigationControllerManager

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

- (void)handlePushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self _markModalStatusIsUpdate];
    [self handleControllerForOperation:GMLNavigationControllerOperationPush
                    fromViewController:self.navigationController.viewControllers.lastObject
                      toViewController:viewController
                              animated:animated];
}
- (void)handlePopViewControllerAnimated:(BOOL)animated {
    NSArray *vcs = self.navigationController.viewControllers;
    NSInteger count = vcs.count;
    if (count <= 1) return;
    [self _markModalStatusIsUpdate];
    [self handleControllerForOperation:GMLNavigationControllerOperationPop
                    fromViewController:vcs[count - 1]
                      toViewController:vcs[count - 2]
                              animated:animated];
}
- (void)handlePopToRootViewControllerAnimated:(BOOL)animated {
    NSArray *vcs = self.navigationController.viewControllers;
    if (vcs.count <= 1) return;
    [self _markModalStatusIsUpdate];
    [self handleMonitorAnimationControllerForOperation:GMLNavigationControllerOperationPop fromViewController:vcs.lastObject toViewController:vcs.firstObject resultCallback:^(BOOL isFinished) {
        if (!isFinished) return;
        NSRange range = NSMakeRange(1, vcs.count - 1);
        [self.appearanceManager removeAppearancesInRange:range];
    }];
}
- (void)handlePopToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *vcs = self.navigationController.viewControllers;
    NSInteger count = vcs.count;
    if (count <= 1) return;
    NSInteger index = [vcs indexOfObject:viewController];
    if (index == NSNotFound || index == count - 1) return;
    [self _markModalStatusIsUpdate];
    [self handleControllerForOperation:GMLNavigationControllerOperationPop
                    fromViewController:vcs[count - 1]
                      toViewController:vcs[index]
                              animated:animated];
}
- (void)handleSetViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    BOOL isAnimated = animated && viewControllers.lastObject != self.navigationController.viewControllers.lastObject;
    __weak typeof(self) weakself = self;
    void (^configurationBarAppearance) (void) = ^{
        [weakself _resetBarAppearanceWithViewControllers:viewControllers];
    };
    [self _markModalStatusIsUpdate];
    if (isAnimated) {
        [self handleMonitorAnimationControllerForOperation:GMLNavigationControllerOperationPush fromViewController:self.navigationController.viewControllers.lastObject toViewController:viewControllers.lastObject resultCallback:^(BOOL isFinished) {
            if (isFinished) return;
            configurationBarAppearance();
        }];
    }else {
        configurationBarAppearance();
    }
}

- (void)handleControllerForOperation:(GMLNavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC animated:(BOOL)animated {
    if (operation == GMLNavigationControllerOperationNone) return;
    
    void (^configurationBarAppearance) (void) = ^{
        switch (operation) {
            case GMLNavigationControllerOperationPush: {
                [self _getBarAppearanceWithViewController:toVC item:^(GMLNavigationBarAppearanceItem *item) {
                    [self.appearanceManager push:item];
                } nilAppearance:^{
                    [self.appearanceManager pushNilAppearance];
                }];
            } break;
            case GMLNavigationControllerOperationPop:
                [self.appearanceManager pop]; break;
            case GMLNavigationControllerOperationNone: break;
        }
    };
    if (animated) {
        if (GMLNavigationControllerOperationPush == operation) {
            configurationBarAppearance();
        }
        __weak typeof(self) weakself = self;
        // 进行动画时进行 viewController 的监听
        // 为了避免取消动画(返回手势取消Pop)后导航栏的配置出错
        [self handleMonitorAnimationControllerForOperation:operation fromViewController:fromVC toViewController:toVC resultCallback:^(BOOL isFinished) {
            if (isFinished) {
                if (GMLNavigationControllerOperationPop == operation) {
                    configurationBarAppearance();
                }
            }else if (GMLNavigationControllerOperationPush == operation) {
                // 失败时如果是 push 需要外观管理器 pop 下
                [weakself.appearanceManager pop];
            }
        }];
    }else {
        // 不进行动画时直接进行设置
        configurationBarAppearance();
    }
}

- (void)updateNavigationControllerConfigure {
    if (!self.isNeedUpdate) return;
    [self _resetBarAppearanceWithViewControllers:self.navigationController.viewControllers];
    [self navigationController:self.navigationController willShowViewController:self.navigationController.viewControllers.lastObject animated:false];
    self.isNeedUpdate = false;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isHiddenNavigationBar = false;
    if ([viewController conformsToProtocol:@protocol(GMLConfigureNavigationController)]) {
        isHiddenNavigationBar = [(id<GMLConfigureNavigationController>)viewController isHiddenNavigationBar];
    }
    [navigationController setNavigationBarHidden:isHiddenNavigationBar animated:animated];
}

#pragma mark - GMLNavigationBarAppearanceManagerDelegate
- (void)navigationBarCurrentUsingAppearanceDidChangeManager:(GMLNavigationBarAppearanceManager *)manager {
    [self.appearanceManager applyTo:self.navigationController.navigationBar];
}

#pragma mark - Private
- (void)handleMonitorAnimationControllerForOperation:(GMLNavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC resultCallback:(void(^)(BOOL isFinished))resultCallback {
    void (^end)(BOOL);
    {// 处理动画结束事件，动画包含 fromVC 与 toVC 两个值的状态，所以需要等待两次回调才能返回
        __block NSInteger didFinishedCount = 0;
        __block BOOL result = true;
        end = ^(BOOL isFinished) {
            result = isFinished && result;
            didFinishedCount += 1;
            if (didFinishedCount == 2) {
                !resultCallback?: resultCallback(result);
            }
        };
    }
    {// 处理 fromVC 动画结果，当 fromVC 已经隐藏时表示成功，已经显示时表示失败
        __weak __block id<GMLViewControllerViewStateToken> token = nil;
        __weak UIViewController *weakFromVC = fromVC;
        token = [fromVC gml_addViewState:GMLViewControllerViewStateDidDisappear | GMLViewControllerViewStateDidAppear callback:^(GMLViewControllerViewState state, BOOL animated) {
            end(state == GMLViewControllerViewStateDidDisappear);
            [weakFromVC gml_removeViewStateToken:token];
        }];
    }
    {// 处理 toVC 动画结果，当 toVC 已经显示时表示成功，已经隐藏时表示失败
        __weak __block id<GMLViewControllerViewStateToken> token = nil;
        __weak UIViewController *weakToVC = toVC;
        token = [toVC gml_addViewState:GMLViewControllerViewStateDidDisappear | GMLViewControllerViewStateDidAppear callback:^(GMLViewControllerViewState state, BOOL animated) {
            end(state == GMLViewControllerViewStateDidAppear);
            [weakToVC gml_removeViewStateToken:token];
        }];
    }
}

- (void)_getBarAppearanceWithViewController:(UIViewController *)viewController item:(void(^)(GMLNavigationBarAppearanceItem *item))item nilAppearance:(void(^)(void))nilAppearance {
    if (![viewController conformsToProtocol:@protocol(GMLConfigurationNavigationBarAppearance)]) {
        !nilAppearance?: nilAppearance();
        return;
    }
    if (item == nil) return;
    id<GMLConfigurationNavigationBarAppearance> configuration = (id<GMLConfigurationNavigationBarAppearance>)viewController;
    id<GMLNavigationBarAppearanceProtocol> appearance = [configuration navigationBarAppearanceWithDefaultAppearance:^id<GMLNavigationBarAppearanceProtocol>{
        return [self.appearanceManager defaultAppearance];
    }];
    GMLNavigationBarAppearanceEffectivePeriod effectiveType = GMLNavigationBarAppearanceOnlyMyselfEffective;
    if ([configuration respondsToSelector:@selector(navigationBarAppearanceEffectiveType)]) {
        effectiveType = configuration.navigationBarAppearanceEffectiveType;
    }
    item([[GMLNavigationBarAppearanceItem alloc] initWithAppearance:appearance effectiveType:effectiveType]);
}

- (void)_resetBarAppearanceWithViewControllers:(NSArray<UIViewController *> *)viewControllers {
    [self.appearanceManager removeAllAppearance];
    [self.appearanceManager updateAppearance:^(GMLNavigationBarAppearanceManager * _Nonnull manager) {
        for (UIViewController *vc in viewControllers) {
            [self _getBarAppearanceWithViewController:vc item:^(GMLNavigationBarAppearanceItem *item) {
                [self.appearanceManager push:item];
            } nilAppearance:^{
                [self.appearanceManager pushNilAppearance];
            }];
        }
    }];
}

- (void)_markModalStatusIsUpdate {
    UIViewController *vc = self.navigationController.presentedViewController;
    if (vc == nil || vc.modalPresentationStyle == UIModalPresentationOverCurrentContext) return;
    self.isNeedUpdate = true;
}

#pragma mark - Getter & Setter

- (void)setDefaultNavigationBarAppearance:(id<GMLNavigationBarAppearanceProtocol>)defaultAppearance {
    self.appearanceManager.defaultAppearance = defaultAppearance;
}
- (id<GMLNavigationBarAppearanceProtocol>)defaultNavigationBarAppearance {
    return self.appearanceManager.defaultAppearance;
}

- (GMLNavigationBarAppearanceManager *)appearanceManager {
    if (_appearanceManager == nil) {
        _appearanceManager = [GMLNavigationBarAppearanceManager new];
        _appearanceManager.delegate = self;
    }
    return _appearanceManager;
}

@end
