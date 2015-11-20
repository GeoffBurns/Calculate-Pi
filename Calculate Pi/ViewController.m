//
//  ViewController.m
//  Calculate Pi
//
//  Created by Geoff Burns on 20/11/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//


#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pilabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    startTime = [NSDate date];
    piSoFar = 2;
    iteration = 1;
    progress = 0;
    prevProgress = 0;
    // Do any additional setup after loading the view, typically from a nib.

}

- (RACSignal *)timer {
    return    [[[[[RACSignal interval:1 onScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]]                 startWith:[NSDate date]]
                 takeUntil:
                      [RACSignal merge:@[
                                    [self.stopButton rac_signalForControlEvents:UIControlEventTouchUpInside],
                                    [self.pauseButton rac_signalForControlEvents:UIControlEventTouchUpInside]]]]
                map:^id(NSDate *value) {
        
        progress = [value timeIntervalSinceDate:startTime] + prevProgress;
                    int duration = progress;
        int durationSec = duration % 60;
        int durationMin = duration / 60;
        return [NSString stringWithFormat:@"%ld:%02ld", (long)durationMin, (long)durationSec];
    }] deliverOnMainThread];
}

- (RACSignal *)caculatePiSlow{
            return
    [
                    [RACSignal
                    startLazilyWithScheduler:
                
                    [RACScheduler schedulerWithPriority:RACSchedulerPriorityLow]
                    block: ^(id subscriber)
    {
              float piAsCalcuatedSoFar = 4;
                long n = 1;
                [subscriber sendNext:@"4.0"];
                for (;isRunning ;) {
                    for (int i=0; i<1000; i++, n++) {
                        BOOL isOdd = n % 2;
                        float sign = isOdd ? -1.0 : 1.0;
                        float term = sign / (2.0 * n + 1.0);
                        piAsCalcuatedSoFar += term;
                    }
                    [subscriber sendNext:[NSString stringWithFormat:@"%.20f", piAsCalcuatedSoFar]];
                }
        
                [subscriber sendCompleted];
      
            }]
     
    deliverOnMainThread];
        }


- (RACSignal *)caculatePi{
    return
    [//[
     [RACSignal
      startLazilyWithScheduler:
      [RACScheduler schedulerWithPriority:RACSchedulerPriorityLow]
      block: ^(id subscriber)
      {
          double piAsCalcuatedSoFar = piSoFar;
          long n = iteration;
      
          double oldTerm = 2;
          for (;isRunning ;) {
              for (int i=0; i<10; i++, n++) {
                  double term = oldTerm * n / ( 2.0 * n + 1);
                  piAsCalcuatedSoFar += term;
                  oldTerm = term;
              }
              [subscriber sendNext:[NSString stringWithFormat:@"%.50f", piAsCalcuatedSoFar]];
          }
          
          [subscriber sendCompleted];
          if (isPaused) {
              piSoFar = 2;
              iteration = 1;
          }
          else
              if (isPaused) {
                  piSoFar = piAsCalcuatedSoFar;
                  iteration = n-1;
              }

      }]
     deliverOnMainThread];
}


//Implementing our method
- (IBAction)startPressed{
    startTime = [NSDate date];
    isRunning = true;
    isPaused = false;
    RAC(self,pilabel.text) =  [self caculatePi];
    RAC(self,timeLabel.text) = [self timer];
}

- (IBAction)pausePressed{
    isPaused = true;
    prevProgress = progress;
}

- (IBAction)stopPressed{
    
    isPaused = false;
    isRunning = false;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
