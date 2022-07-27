//
//  ViewController.m
//  GMLTest
//
//  Created by GML on 2022/7/18.
//

#import "ViewController.h"
#import <GML_OC/GMLTimerAdapter.h>
#import <GML_OC/GMLTimeConfiguration.h>

@interface ViewController ()
@property (nonatomic, strong) GMLTimerAdapter *timer1;
@property (nonatomic, strong) GMLTimerAdapter *timer2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self timer1];
    [self timer2];
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
