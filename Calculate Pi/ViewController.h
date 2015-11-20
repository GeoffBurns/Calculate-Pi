//
//  ViewController.h
//  Calculate Pi
//
//  Created by Geoff Burns on 20/11/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIAlertViewDelegate>{
    

    NSDate *startTime;
    BOOL isRunning;
    BOOL isPaused;
    double piSoFar;
    long iteration;
    NSTimeInterval progress;
    NSTimeInterval prevProgress;
    
}
- (IBAction) startPressed;
- (IBAction) pausePressed;
- (IBAction) stopPressed;
@end

