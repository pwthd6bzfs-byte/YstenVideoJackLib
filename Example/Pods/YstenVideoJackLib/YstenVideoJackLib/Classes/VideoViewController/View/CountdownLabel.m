#import "CountdownLabel.h"

@interface CountdownLabel ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int interval;

@end

@implementation CountdownLabel

- (void)dealloc {
    [self stopCountdown];
}

- (void)startCountdown {
    [self stopCountdown]; // 先停止之前的定时器
    [self updateLabel]; // 立即更新一次
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
        // 如果需要定时器在滚动时也能工作，可以将其添加到当前runloop的common mode中
        // [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}



- (void)stopCountdown {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}



- (void)updateLabel {
    self.interval += 1;
    
//    if (interval <= 0) {
//            // 倒计时结束
//        [self stopCountdown];
//        self.text = @"倒计时结束";
//            // 可以在这里触发一个回调
//        return;
//    }
    
        // 将时间差转换为时、分、秒
    NSInteger hours = (_interval) / (60 * 60);
    NSInteger minutes = (_interval) / 60;
    NSInteger seconds = (_interval) % 60;
    
        // 根据需求格式化字符串，这里显示时、分、秒
    self.text = [NSString stringWithFormat:@"%02ld: %02ld: %02ld", hours, minutes, seconds];
}

@end
