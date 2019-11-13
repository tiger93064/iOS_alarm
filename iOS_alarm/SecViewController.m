//
//  SecViewController.m
//  iOS_alarm
//
//  Created by GuantingLiu on 2019/1/7.
//  Copyright © 2019 Guanting Liu. All rights reserved.
//

#import "SecViewController.h"

@interface SecViewController ()
{
    NSInteger random ;
    AVAudioPlayer *player;
    NSInteger key2;
}
@property (weak, nonatomic) IBOutlet UIImageView *image;
- (IBAction)btn1:(id)sender;
- (IBAction)btn2:(id)sender;
- (IBAction)btn3:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn11;
@property (weak, nonatomic) IBOutlet UIButton *btn22;
@property (weak, nonatomic) IBOutlet UIButton *btn33;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    random = arc4random() %2; //取亂數
    key2 =0;
    switch(random)
    {
        case 0:
            
            _image.image = [UIImage imageNamed:@"ios11.png"];
            [_btn11 setTitle:@"(A) 1/2"forState:UIControlStateNormal];
            [_btn22 setTitle:@"(B) 1"forState:UIControlStateNormal];
            [_btn33 setTitle:@"(C) 1/4"forState:UIControlStateNormal];
            
            break;
        case 1:
            _label1.text = @"Suppose you roll three dice.";
            _label2.text = @"Find the expect value of the sum.";
            [_btn11 setTitle:@"(A) 7/2"forState:UIControlStateNormal];
            [_btn22 setTitle:@"(B) 7"forState:UIControlStateNormal];
            [_btn33 setTitle:@"(C) 21/2"forState:UIControlStateNormal];
            break;
    }
    NSString *path = [[NSBundle mainBundle]pathForResource:@"NyanCat" ofType:@"mp3"];
    NSURL *url = [NSURL URLWithString:path];
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [player play];
}

- (IBAction)btn1:(id)sender {
    if (random ==0)
    {
        [player stop];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Congratulations !"
                                                                       message:@"Correct"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {        [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"66666");
        
    }
    else if(random ==1)
    {
        UIAlertView *msg=[[UIAlertView alloc] initWithTitle:@"Warn !"message:@"Wrong Answer"delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        [msg show];
    }
}

- (IBAction)btn2:(id)sender {
    if (random ==0)
    {
        UIAlertView *msg=[[UIAlertView alloc] initWithTitle:@"Warn !"message:@"Wrong Answer"delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        [msg show];
        
        
    }
    else if(random ==1)
    {
        UIAlertView *msg=[[UIAlertView alloc] initWithTitle:@"Warn !"message:@"Wrong Answer"delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        [msg show];
    }
    
}

- (IBAction)btn3:(id)sender {
    if (random ==0)
    {
        UIAlertView *msg=[[UIAlertView alloc] initWithTitle:@"Warn !"message:@"Wrong Answer"delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        [msg show];
        
    }
    else if(random ==1)
    {
        [player stop];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Congratulations !"
                                                                       message:@"Correct"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {        [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(IBAction)shortcut{
    if(key2==0){
        [player stop];
        ThrViewController *game3 = [[ThrViewController alloc] init]; //test olny
        game3 =[self.storyboard instantiateViewControllerWithIdentifier:@"game3"];
        [game3 dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController pushViewController:game3 animated:YES];
    }
    key2=1;
}
@end
