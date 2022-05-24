//
//  GMLNavigationController.h
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import <UIKit/UINavigationController.h>

NS_ASSUME_NONNULL_BEGIN
@protocol GMLNavigationBarAppearanceProtocol;
@interface GMLNavigationController : UINavigationController

@property (nullable, nonatomic, copy) id<GMLNavigationBarAppearanceProtocol> defaultAppearance;

@end

NS_ASSUME_NONNULL_END
