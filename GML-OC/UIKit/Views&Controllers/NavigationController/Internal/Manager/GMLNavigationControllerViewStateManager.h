//
//  GMLNavigationControllerViewStateManager.h
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GMLNavigationControllerViewStateManager;
@protocol GMLNavigationStateManagerDelegate <NSObject>
@optional
- (void)manager:(GMLNavigationControllerViewStateManager *)manager willAppearViewController:(UIViewController *)viewController;
- (void)manager:(GMLNavigationControllerViewStateManager *)manager didAppearViewController:(UIViewController *)viewController;
- (void)manager:(GMLNavigationControllerViewStateManager *)manager willDisappearViewController:(UIViewController *)viewController;
- (void)manager:(GMLNavigationControllerViewStateManager *)manager didDisappearViewController:(UIViewController *)viewController;

@end

@interface GMLNavigationControllerViewStateManager : NSObject

@property (nullable, nonatomic, weak) UINavigationController *navigationController;

@property (nullable, nonatomic, weak) id<GMLNavigationStateManagerDelegate> delegate;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated;
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
