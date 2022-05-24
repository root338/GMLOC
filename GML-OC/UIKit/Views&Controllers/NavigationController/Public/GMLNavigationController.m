//
//  GMLNavigationController.m
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import "GMLNavigationController.h"
#import "GMLNavigationControllerViewStateManager.h"

@interface GMLNavigationController ()<GMLNavigationStateManagerDelegate>
@property (nonatomic, strong) GMLNavigationControllerViewStateManager *viewStateManager;
@end

@implementation GMLNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.viewStateManager pushViewController:viewController animated:animated];
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.viewStateManager popViewControllerAnimated:animated];
    return [super popViewControllerAnimated:animated];
}
- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    [self.viewStateManager popToRootViewControllerAnimated:animated];
    return [super popToRootViewControllerAnimated:animated];
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [self.viewStateManager setViewControllers:viewControllers animated:animated];
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark - GMLNavigationStateManagerDelegate
- (void)manager:(GMLNavigationControllerViewStateManager *)manager willAppearViewController:(UIViewController *)viewController {
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), viewController);
}
- (void)manager:(GMLNavigationControllerViewStateManager *)manager didAppearViewController:(UIViewController *)viewController {
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), viewController);
}
- (void)manager:(GMLNavigationControllerViewStateManager *)manager willDisappearViewController:(UIViewController *)viewController {
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), viewController);
}
- (void)manager:(GMLNavigationControllerViewStateManager *)manager didDisappearViewController:(UIViewController *)viewController {
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), viewController);
}

#pragma mark - Getter & Setter
- (GMLNavigationControllerViewStateManager *)viewStateManager {
    if (_viewStateManager == nil) {
        _viewStateManager = [[GMLNavigationControllerViewStateManager alloc] initWithNavigationController:self];
        _viewStateManager.delegate = self;
    }
    return _viewStateManager;
}
@end
