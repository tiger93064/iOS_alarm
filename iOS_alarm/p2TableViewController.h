//
//  p2TableViewController.h
//  iOS_alarm
//
//  Created by GuantingLiu on 2018/12/24.
//  Copyright © 2018 Guanting Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface p2TableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
-(id) getSelectedItem:(NSString *)str clockinformation:(NSArray *)clockinfo;

@end

NS_ASSUME_NONNULL_END
