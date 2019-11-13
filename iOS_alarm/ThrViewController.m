//
//  ThrViewController.m
//  iOS_alarm
//
//  Created by Guanting on 2019/1/8.
//  Copyright © 2019 Guanting Liu. All rights reserved.
//

#import "ThrViewController.h"

@interface ThrViewController ()
{
    WKWebView *wk;
    AVAudioPlayer *player;
}
@end

@implementation ThrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWebkitView];
    
    // Load your website: this allows reCaptcha to have the correct referrer header.
    [wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://yunnet.yuntech.edu.tw/login"]]];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"NyanCat" ofType:@"mp3"];
    NSURL *url = [NSURL URLWithString:path];
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [player play];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Solve the reCaptcha!!"
                                                                   message:@"or the NyanCat won't stop"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (WKUserScript*)readScript {
    NSString *scriptSrc = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"reCaptcha" ofType:@"js"]
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    return [[WKUserScript alloc] initWithSource:scriptSrc
                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                               forMainFrameOnly:true];
}

- (void)initWebkitView {
    WKUserContentController *wkController = [[WKUserContentController alloc] init];
    
    [wkController addScriptMessageHandler:self name:@"reCaptchaiOS"];
    [wkController addUserScript:[self readScript]];
    
    WKWebViewConfiguration *wkConf = [[WKWebViewConfiguration alloc] init];
    [wkConf setUserContentController:wkController];
    
    wk = [[WKWebView alloc] initWithFrame:self.view.frame
                            configuration:wkConf];
    
    wk.backgroundColor = [UIColor clearColor];
    wk.opaque = NO;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSArray<NSString*> *args = (NSArray*)message.body;
    
    if ([args[0] isEqualToString:@"didLoad"])
        [self captchaDidLoad];
    else if ([args[0] isEqualToString:@"didSolve"])
        [self captchaDidSolve:args[1]];
    else if ([args[0] isEqualToString:@"didExpire"])
        [self captchaDidExpire];
}

- (void)captchaDidLoad {
    [wk setFrame:self.view.frame];
    [self.view addSubview:wk];
}

- (void)captchaDidSolve:(NSString *)response {
    NSLog(@"Solved!!\n%@", response);
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

- (void)captchaDidExpire {
    NSLog(@"Captcha Expired");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warn !"
                                                                  message:@"Captcha Expired"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {        [self->wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://yunnet.yuntech.edu.tw/login"]]];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
