//
//  ViewController.m
//  GMLTest
//
//  Created by GML on 2022/7/18.
//

#import "ViewController.h"
#import <GML_OC/GMLTimerAdapter.h>
#import <GML_OC/GMLTimeConfiguration.h>

#import <GML_OC/Runtime+GMLAdd.h>

typedef NS_ENUM(NSInteger, FooManChu) {
    FooManChuNone
};
struct YorkshireTeaStruct {
    int a;
};

union MoneyUnion {
    int b;
};

@interface ViewController ()

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger a;
@property (nonatomic, assign) float b;
@property (nonatomic, strong) NSString *str;
@property (copy, nonatomic) GMLTimerAdapter *timer1;
@property (strong, nonatomic) GMLTimerAdapter *timer2;


@property (nonatomic, copy) NSNumber *number;
@property (nonatomic, strong, readonly) NSArray *array;
@property (nonatomic) SEL selector;
@property char charDefault;
@property double doubleDefault;
@property enum FooManChu enumDefault;
@property float floatDefault;
@property int intDefault;
@property long longDefault;
@property short shortDefault;
@property signed signedDefault;
@property struct YorkshireTeaStruct structDefault;
@property unsigned unsignedDefault;
@property int (*functionPointerDefault)(char *);
@property (nullable, nonatomic, copy) NSString * (^block) (NSArray *array, int d);
@property id idDefault;
@property union MoneyUnion unionDefault;
@property int *intPointer;
@property void *voidPointerDefault;
@property int intSynthEquals;
@property(getter=intGetFoo, setter=intSetFoo:) int intSetterGetter;
@property(readonly) int intReadonly;
@property(getter=isIntReadOnlyGetter, readonly) int intReadonlyGetter;
@property(readwrite) int intReadwrite;
@property(assign) int intAssign;
@property(retain) id idRetain;
@property(copy) id idCopy;
@property(nonatomic) int intNonatomic;
@property(nonatomic, readonly, copy) id idReadonlyCopyNonatomic;
@property(nonatomic, readonly, retain) id idReadonlyRetainNonatomic;
@end

@interface UIViewController (__Private)

@end

@implementation UIViewController (__Private)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController swizzledInstanceMethodAtSelector:@selector(viewWillAppear:) withInstanceMethodAtSelector:@selector(ggg_viewWillAppear:)];
    });
}

- (void)ggg_viewWillAppear:(BOOL)animation {
    [self ggg_viewWillAppear:animation];
}

@end

@interface NSString (__Private)

@end

@implementation NSString (__Private)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSString swizzledInstanceMethodAtSelector:@selector(isEqual:) withInstanceMethodAtSelector:@selector(gg_isEqual:)];
        [NSString swizzledInstanceMethodAtSelector:@selector(isEqualToString:) withInstanceMethodAtSelector:@selector(gg_isEqualToString:)];
    });
}

- (BOOL)gg_isEqual:(id)object {
    return [self gg_isEqual:object];
}
- (BOOL)gg_isEqualToString:(NSString *)str {
    return [self gg_isEqualToString:str];
}

@end

@interface TestA : NSObject

@end
@implementation TestA

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self timer1];
    //    [self timer2];
    
    //    [[self class] enumerateProperysUsingBlock:^(objc_property_t  _Nonnull property_t, BOOL * _Nonnull stop) {
    //        NSLog(@"%@: %@", [NSString stringWithUTF8String:property_getName(property_t)], [NSString stringWithUTF8String:property_getAttributes(property_t)]);
    //
    //        enumerateProperyAttributeList(property_t, ^(objc_property_attribute_t attribute, BOOL * _Nonnull stop) {
    //            NSLog(@"\t%@, %@", [NSString stringWithUTF8String:attribute.name], [NSString stringWithUTF8String:attribute.value]);
    //        });
    //    }];
    //    NSNumber *num1  = [NSNumber numberWithInt:1];
    //    NSNumber *num2 = [NSNumber numberWithFloat:1];
    //    NSLog(@"isEqual: %i", [num1 isEqual:num2]);
    //    NSLog(@"isEqualToNumber: %i", [@"" isEqualToString:@""]);
    
    //    NSMutableArray *mArr = NSMutableArray.array;
    //    NSArray *arr = NSArray.array;
    //    NSSet *set = NSSet.set;
    //    NSMutableSet *mSet = NSMutableSet.set;
    //    NSOrderedSet *orderedSet = NSOrderedSet.orderedSet;
    //    NSMutableOrderedSet *mOrderedSet = NSMutableOrderedSet.orderedSet;
    //    NSHashTable *weakhashTable = [NSHashTable weakObjectsHashTable];
    //    NSHashTable *strongHashTable = [NSHashTable hashTableWithOptions:NSHashTableStrongMemory];
    //    NSLog(@"%@, %@", NSStringFromClass(arr.class), NSStringFromClass(mArr.class));
    //    NSLog(@"%@, %@", NSStringFromClass(set.class), NSStringFromClass(mSet.class));
    //    NSLog(@"%@, %@", NSStringFromClass(orderedSet.class), NSStringFromClass(mOrderedSet.class));
    //    NSLog(@"%@, %@", NSStringFromClass(weakhashTable.class), NSStringFromClass(strongHashTable.class));
    
    //    NSLog(@"%i, %i", [@[@1] isEqualToArray:^{
    //        NSMutableSet *mArr = [[NSMutableSet alloc] init];
    //        [mArr addObject:[NSNumber numberWithFloat:1]];
    //        return mArr;
    //    }()], [arr isKindOfClass:NSMutableArray.class]);
    
    //    TestA *a = TestA.new;
    //    TestA *b = TestA.new;
    //    NSLog(@"a, b <==> %i, %i", [a isEqual:b], [a isEqualGML:b]);
    NSNumber *num = @1;
    NSLog(@"%p", num);
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"abcdefghij"];
        });
    }
    //    NSLog(@"%p", num->isa);
    
    NSLog(@"");
}

- (GMLTimerAdapter *)timer1 {
    if (_timer1 == nil) {
        
        __weak typeof(self) weakself = self;
        _timer1 = [GMLTimerAdapter scheduledTimerWithConfiguration:^(id<GMLTimeConfiguration>  _Nonnull configuration) {
            configuration.interval = 1;
            configuration.repeats = true;
            __block NSInteger count = 1;
            configuration.block = ^(GMLTimerAdapter * _Nonnull timer) {
                NSLog(@"timer 1: %li", (long)count++);
                if (count == 2) {
                    [weakself.timer2 resume];
                    [weakself.timer2 addToRunLoop];
                }
                if (count == 4) {
                    [weakself.timer2 suspend];
                }
                if (count == 8) {
                    [weakself.timer2 resume];
                }
            };
            NSLog(@"..");
        }];
//        _timer1.interval;
        NSLog(@"...%i", [_timer1 conformsToProtocol:@protocol(GMLTimeConfiguration)]);
    }
    return _timer1;
}
- (GMLTimerAdapter *)timer2 {
    if (_timer2 == nil) {
        _timer2 = [GMLTimerAdapter timerWithConfiguration:^(id<GMLTimeConfiguration>  _Nonnull configuration) {
            configuration.interval = 1;
            configuration.repeats = true;
            configuration.block = ^(GMLTimerAdapter * _Nonnull timer) {
                NSLog(@"timer 2");
            };
        }];
    }
    return _timer2;
}

@end
