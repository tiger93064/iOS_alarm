//
//  mycustomcell.m
//  w5a
//
//  Created by Guanting Liu on 2018/10/15.
//  Copyright © 2018 Guanting Liu. All rights reserved.
//

#import "mycustomcell.h"

@implementation mycustomcell
@synthesize mylabel2;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)textChanged:(id)sender {
    
}

@end
