#import "LaunchAnimationViewController.h"
#import "UIImage+GIF.h"
#import "ViewController.h"


@interface LaunchAnimationViewController ()

@end

@implementation LaunchAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UIImageView *launchAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 140, 220, 350)];
    // frame可根据图片大小设定
   // launchAnimationView.frame = self.view.bounds;
    // 创建gifImage,传入Gif图片名即可
    UIImage *gifImage = [UIImage sd_animatedGIFNamed:@"logo"];
    NSLog(@"put!");
    launchAnimationView.image = gifImage;
    [self.view addSubview:launchAnimationView];
    
    // 执行隐藏动画，在动画完成后切换主界面
    [UIView animateWithDuration:0.2 delay:1.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        launchAnimationView.alpha = 0;
    } completion:^(BOOL finished) {
        UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"6969"];
        [self.navigationController pushViewController:vc animated:YES ];
    }];
}

@end
