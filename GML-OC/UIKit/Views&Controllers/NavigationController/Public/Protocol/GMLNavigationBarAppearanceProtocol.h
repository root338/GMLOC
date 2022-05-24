//
//  GMLNavigationBarAppearanceProtocol.h
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UIColor, UIImage;
@protocol GMLNavigationBarAppearanceProtocol <NSObject, NSCopying>
@property (nullable, nonatomic, copy, readonly) UIColor *tintColor;
@property (nullable, nonatomic, copy, readonly) UIColor *backgroundColor;
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;
@property (nullable, nonatomic, copy, readonly) UIImage *backIndicatorImage;
@property (nullable, nonatomic, copy, readonly) UIImage *backIndicatorTransitionMaskImage;
@end

@protocol GMLMutableNavigationBarAppearanceProtocol <GMLNavigationBarAppearanceProtocol, NSMutableCopying>
@property (nullable, nonatomic, copy) UIColor *tintColor;
@property (nullable, nonatomic, copy) UIColor *backgroundColor;
@property (nullable, nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;
@property (nullable, nonatomic, copy) UIImage *backIndicatorImage;
@property (nullable, nonatomic, copy) UIImage *backIndicatorTransitionMaskImage;
@end

NS_ASSUME_NONNULL_END
