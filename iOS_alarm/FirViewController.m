//
//  FirViewController.m
//  iOS_alarm
//
//  Created by GuantingLiu on 2019/1/5.
//  Copyright © 2019 Guanting Liu. All rights reserved.
//

#import "FirViewController.h"

@interface FirViewController ()
{
    UILabel *progress;
    NSTimer *timer;
    int currSec;
    AVAudioPlayer *player;
    NSInteger key;
    NSTimer *timer2;
    NSInteger key2;

}
@end

@implementation FirViewController
NSInteger count;
NSString *Message = @"Tap !";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    key=0;
    key2=0;
    count =0;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"NyanCat" ofType:@"mp3"];
    NSURL *url = [NSURL URLWithString:path];
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    _lebel1.text = Message;
    progress = [[UILabel alloc] initWithFrame:CGRectMake(122, 425, 122, 21)];
    progress.textColor = [UIColor blackColor];
    [progress setText:@"Time : 15"];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    currSec=15;
    [self start];
    [player play];

    
    
}
- (void)start
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
- (void)timerFired
{
    currSec--;
    [progress setText:[NSString stringWithFormat:@"%@%02d",@"Time : ",currSec]];
    
    if(currSec == 0)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warn !"
                                                                       message:@"未達到標準"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {NSLog(@"a");}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        [timer invalidate];
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tap:(id)sender {
    count++;
    _lebel1.text = [[NSString alloc] initWithFormat : @"%ld",(long)count];
    if(count == 50)
    {
        [player stop];
        [timer invalidate];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Congratulations !"
                                                                       message:@"達到標準"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {        [self.navigationController popViewControllerAnimated:YES];
}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
- (IBAction)retry:(id)sender {
    [timer invalidate];
    [progress setText:@"Time : 15"];
    count = 0;
    _lebel1.text = @"Tap !";
    currSec=15;
    [self start];
    
}
-(IBAction)shortcut{
    if(key2==0){
        [player stop];
        SecViewController *game2 = [[SecViewController alloc] init]; //test olny
        game2 =[self.storyboard instantiateViewControllerWithIdentifier:@"game2"];
        [game2 dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController pushViewController:game2 animated:YES];
    }
    key2=1;
}

@end
