//
//  GMLNavigationBarAppearanceProtocol.h
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UIColor, UIImage;

// 实现 NSMutableCopying 时创建的对象必须实现 GMLMutableNavigationBarAppearanceProtocol 协议
@protocol GMLNavigationBarAppearanceProtocol <NSObject, NSCopying, NSMutableCopying>
@property (nullable, nonatomic, copy, readonly) UIColor *tintColor;
@property (nullable, nonatomic, copy, readonly) UIColor *backgroundColor;
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;
@property (nullable, nonatomic, copy, readonly) UIImage *backIndicatorImage;
@property (nullable, nonatomic, copy, readonly) UIImage *backIndicatorTransitionMaskImage;
@end

@protocol GMLMutableNavigationBarAppearanceProtocol <GMLNavigationBarAppearanceProtocol, NSCopying>
@property (nullable, nonatomic, copy) UIColor *tintColor;
@property (nullable, nonatomic, copy) UIColor *backgroundColor;
@property (nullable, nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;
@property (nullable, nonatomic, copy) UIImage *backIndicatorImage;
@property (nullable, nonatomic, copy) UIImage *backIndicatorTransitionMaskImage;
@end

NS_ASSUME_NONNULL_END
