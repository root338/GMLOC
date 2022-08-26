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
- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.configureManager handlePopToViewController:viewController animated:animated];
    return [super popToViewController:viewController animated:animated];
}
- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    [self.configureManager handlePopToRootViewControllerAnimated:animated];
    return [super popToRootViewControllerAnimated:animated];
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [self.configureManager handleSetViewControllers:viewControllers animated:animated];
    [super setViewControllers:viewControllers animated:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 在模态加载时（导航栏不进行刷新），调用 push/pop 等方法时，正常的代理方法没有进行调用且pop的控制器的 Disappear 方法也不会调用，所以在此过程中配置管理器会加一个标记，然后在导航控制器即将显示时刷新下整个导航栏的配置项
    [_configureManager updateNavigationControllerConfigure];
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
