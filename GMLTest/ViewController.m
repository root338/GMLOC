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

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self timer1];
//    [self timer2];
    
    [[self class] enumerateProperysUsingBlock:^(objc_property_t  _Nonnull property_t, BOOL * _Nonnull stop) {
        NSLog(@"%@: %@", [NSString stringWithUTF8String:property_getName(property_t)], [NSString stringWithUTF8String:property_getAttributes(property_t)]);
        
//        enumerateProperyAttributeList(property_t, ^(objc_property_attribute_t attribute, BOOL * _Nonnull stop) {
//            NSLog(@"\t%@, %@", [NSString stringWithUTF8String:attribute.name], [NSString stringWithUTF8String:attribute.value]);
//        });
    }];
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
