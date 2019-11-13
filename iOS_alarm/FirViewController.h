//
//  FirViewController.h
//  iOS_alarm
//
//  Created by GuantingLiu on 2019/1/5.
//  Copyright © 2019 Guanting Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SecViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface FirViewController : UIViewController
- (IBAction)tap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lebel1;
- (IBAction)retry:(id)sender;
@end

NS_ASSUME_NONNULL_END
