//
//  GMLObjectCompareConfiguration.h
//  TestLineCommand
//
//  Created by GML on 2022/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GMLObjectCompareType) {
    GMLObjectCompareTypeProperty,
    GMLObjectCompareTypeIvar,
};

@interface GMLObjectCompareConfiguration : NSObject

@property (nonatomic, assign) GMLObjectCompareType type;
@property (nullable, nonatomic, copy) BOOL (^compareClass) (Class class1, Class class2);
@property (nullable, nonatomic, copy) BOOL (^compareDictionary) (NSDictionary *dict1, NSDictionary *dict2);
@property (nullable, nonatomic, copy) BOOL (^compareSet) (NSSet *set1, NSSet *set2);

@end

NS_ASSUME_NONNULL_END
