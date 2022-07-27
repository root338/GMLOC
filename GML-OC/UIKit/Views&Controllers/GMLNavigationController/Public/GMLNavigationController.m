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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self.configureManager;
}
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

- (void)setDefaultNavigationBarAppearance:(id<GMLNavigationBarAppearanceProtocol>)defaultAppearance {
    self.configureManager.defaultNavigationBarAppearance = defaultAppearance;
}
- (id<GMLNavigationBarAppearanceProtocol>)defaultNavigationBarAppearance {
    return self.configureManager.defaultNavigationBarAppearance;
}

- (GMLConfigureNavigationControllerManager *)configureManager {
    if (_configureManager == nil) {
        _configureManager = [[GMLConfigureNavigationControllerManager alloc] initWithNavigationController:self];
    }
    return _configureManager;
}

@end
