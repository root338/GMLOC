//
//  GMLNavigationController.m
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import "GMLNavigationController.h"
#import "GMLConfigureNavigationControllerManager.h"

@interface GMLNavigationController ()
@property (nonatomic, strong) GMLConfigureNavigationControllerManager *configureManager;
@end

@implementation GMLNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.configureManager handlePushViewController:viewController animated:animated];
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.configureManager handlePopViewControllerAnimated:animated];
    return [super popViewControllerAnimated:animated];
}
- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    [self.configureManager handlePopToRootViewControllerAnimated:animated];
    return [super popToRootViewControllerAnimated:animated];
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [self.configureManager handleSetViewControllers:viewControllers animated:animated];
    [super setViewControllers:viewControllers animated:animated];
}
#pragma mark - Getter & Setter

- (void)setDefaultAppearance:(id<GMLNavigationBarAppearanceProtocol>)defaultAppearance {
    self.configureManager.defaultAppearance = defaultAppearance;
}
- (id<GMLNavigationBarAppearanceProtocol>)defaultAppearance {
    return self.configureManager.defaultAppearance;
}

- (GMLConfigureNavigationControllerManager *)configureManager {
    if (_configureManager == nil) {
        _configureManager = [[GMLConfigureNavigationControllerManager alloc] initWithNavigationController:self];
    }
    return _configureManager;
}

@end
