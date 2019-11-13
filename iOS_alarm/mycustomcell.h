//
//  mycustomcell.h
//  w5a
//
//  Created by Guanting Liu on 2018/10/15.
//  Copyright © 2018 Guanting Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface mycustomcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *mylabel2;
- (IBAction)textChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mylabel1;
@end

NS_ASSUME_NONNULL_END
