//
//  ViewController.h
//  iOS_alarm
//
//  Created by Guanting Liu on 2018/12/10.
//  Copyright © 2018 Guanting Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "p2TableViewController.h"
#import "FirViewController.h"
#import "SecViewController.h"
#import "ThrViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectV;
@property (weak, nonatomic) IBOutlet UITableView *tableV;

@property (weak, nonatomic) IBOutlet UIDatePicker *datapicker;
- (IBAction)picker:(id)sender;
- (IBAction)btnRefresh:(id)sender;


@end

