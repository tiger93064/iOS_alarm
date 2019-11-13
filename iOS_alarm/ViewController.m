//
//  ViewController.m
//  iOS_alarm
//
//  Created by Guanting Liu on 2018/12/10.
//  Copyright © 2018 Guanting Liu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableDictionary *data;
    NSInteger numOfClock;
    NSArray *aIndex;
    NSInteger selected;
    
    UIImage *clockimg;
    NSInteger LengthH;
    NSInteger LengthM;
    
    NSTimer *timer;
    NSInteger remainT;
    
    AVAudioPlayer *player;
    NSInteger key2;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    aIndex = [NSArray arrayWithObjects:@"重複",@"標籤",@"提示聲", nil];
    LengthH = 65; LengthM = 130;
    selected = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    key2=0;
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.hidesBackButton = YES;
    [self initial];
    [self fillinfo];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"NyanCat" ofType:@"mp3"];
    NSURL *url = [NSURL URLWithString:path];
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [player play];
    [player stop];
    
}


-(void)initial{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Data.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: filePath]) {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        numOfClock = [data count];
        NSLog(@"exist.");

    }
    else{
        NSLog(@"No data found.");
        numOfClock = 0;
        data = [NSMutableDictionary new];
        for(NSInteger i=0;i<9;i++){
            NSString *index = [[NSString alloc] initWithFormat:@"%ld",i];
            NSMutableArray *clockinfo = [NSMutableArray arrayWithObjects:@"0",@"6",@"9",@"AM",@"1234567",@"Waaaaak",@"喵喵",index, nil];
            NSString *key = [[NSString alloc]initWithFormat:@"%ld",i];
            [data setObject:clockinfo forKey:key];
        }
        if ([data writeToFile:filePath atomically: YES]) NSLog(@"writed");
        else NSLog(@"writed wrong.");
        [_collectV reloadData];
    }
    
}







- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if(data == nil) return 1;
    return 9;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width-60, self.view.frame.size.width-50);
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row == numOfClock -1 || numOfClock == 0 ){                                                 //set the last cell to add
//        NSLog(@"hit");
//        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
//        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add.png"]];
//        cell.backgroundView = view;
//        return cell;
//    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    
    NSArray *dict = [[NSArray alloc]initWithArray:[data objectForKey:[[NSString alloc]initWithFormat:@"%ld",indexPath.row]] copyItems:YES];
    UIView *view = [UIView alloc];
    if([[dict objectAtIndex:0]integerValue]==1){
        [self drawPointerLineH:[[dict objectAtIndex:1]integerValue] dataM:[[dict objectAtIndex:2]integerValue]];
        view = [[UIImageView alloc]initWithImage:clockimg];
    }
    else{
        view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"supernowclock.png"]];
    }
    
  //  view.backgroundColor = [UIColor blueColor];
    UILabel *lab = [[UILabel alloc]init];
    lab.text =@"heyyy";
    
    [view addSubview:lab];
    cell.backgroundView = view;
    
//    if(selected == indexPath.row) cell.backgroundColor = [UIColor colorWithRed:200.0/255 green:210.0/255 blue:255.0/255 alpha:1];
//    else cell.backgroundColor = [UIColor colorWithRed:211.0/255 green:236.0/255 blue:255.0/255 alpha:1];


    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld touched!",indexPath.row);
    selected = indexPath.row;
    [self fillinfo];
    [collectionView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Data.plist"];
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath]; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellidd" forIndexPath:indexPath];
    cell.textLabel.text = [aIndex objectAtIndex:indexPath.row];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    NSArray *dict = [[NSArray alloc]initWithArray:[data objectForKey:[[NSString alloc]initWithFormat:@"%ld",selected]] copyItems:YES];
    if (indexPath.row == 0){
        cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@"週%@",[dict objectAtIndex:4]];
    }
    else if (indexPath.row ==1){
        cell.detailTextLabel.text = [dict objectAtIndex:5];
    }
    else if (indexPath.row == 2){
        cell.detailTextLabel.text = [dict objectAtIndex:6];
    }
    
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Data.plist"];
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];     //load latest data.
    p2TableViewController *p2 = [[p2TableViewController alloc] getSelectedItem:[aIndex objectAtIndex:indexPath.row] clockinformation:[data objectForKey:[[NSString alloc]initWithFormat:@"%ld",selected]]];
    [self.navigationController pushViewController:p2 animated:YES];
}


-(void)drawPointerLineH:(NSInteger)H dataM:(NSInteger)M{
    double tempX,tempY;
    double thetaH,thetaM;
    if(H>12) H-=12;
    thetaH = 30 * H + 30.0 * (M/60.0)-90;
    thetaM = 360 * (M/60.0)-90;
    
    tempX = LengthH * cos((double)thetaH / 180.0 * M_PI);
    tempY = LengthH * sin((double)thetaH / 180.0 * M_PI);
    
    UIImage *originalImage = [UIImage imageNamed:@"supernowclock.png"];
   // UIColor *lineColor = [UIColor colorWithRed:1 green:0.756 blue:0.784 alpha:1];
    UIColor *lineColor = [UIColor colorWithRed:59.0/255 green:80.0/255 blue:113.0/255 alpha:1];
    
    UIGraphicsBeginImageContext(originalImage.size);
    
    // Pass 1: Draw the original image as the background
    [originalImage drawAtPoint:CGPointMake(0,0)];
    
    // Pass 2: Draw the line on top of original image
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 15.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextMoveToPoint(context, 240, 240);
    CGContextAddLineToPoint(context, tempX +240, tempY+240);
    CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
    
    tempX = LengthM * cos((double)thetaM / 180.0 * M_PI);
    tempY = LengthM * sin((double)thetaM / 180.0 * M_PI);
    
    CGContextMoveToPoint(context, 240, 240);
    CGContextAddLineToPoint(context, tempX +240, tempY+240);
    CGContextStrokePath(context);
    
    // Create new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    
    clockimg = newImage;
}
-(void)fillinfo{
    NSArray *dict = [[NSArray alloc]initWithArray:[data objectForKey:[[NSString alloc]initWithFormat:@"%ld",selected]] copyItems:YES];
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    NSString *str = [[NSString alloc]initWithFormat:@"%@:%@ AM",[dict objectAtIndex:1],[dict objectAtIndex:2]];
    NSDate *date=[formatter dateFromString:str];
    [self.datapicker setDate:date];
    
}
- (IBAction)picker:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"h"];
    NSString *strH = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datapicker.date]];
    [formatter setDateFormat:@"m"];
    NSString *strM = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datapicker.date]];
    [formatter setDateFormat:@"a"];
    NSString *strA = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datapicker.date]];


    NSLog(@"%@ %@ %@",strH,strM,strA);

   // NSMutableArray *clockinfo = [NSMutableArray arrayWithObjects:@"1",strH,strM,@"1234567",@"喵喵", nil];
    NSString *key = [[NSString alloc]initWithFormat:@"%ld",selected];
    NSMutableArray *clockinfo = [NSMutableArray arrayWithArray:[data objectForKey:key]];
    [clockinfo replaceObjectAtIndex:0 withObject:@"1"];
    [clockinfo replaceObjectAtIndex:1 withObject:strH];
    [clockinfo replaceObjectAtIndex:2 withObject:strM];
    [clockinfo replaceObjectAtIndex:3 withObject:strA];


    [data setObject:clockinfo forKey:key];
    
    [self.collectV reloadData];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);   //save file
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Data.plist"];
    [data writeToFile:filePath atomically:YES];
    
    [self signClock];
    
//    SecViewController *game2 = [[SecViewController alloc] init];        //test olny
//    game2 =[self.storyboard instantiateViewControllerWithIdentifier:@"game2"];
//    [game2 dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController pushViewController:game2 animated:YES];
//    FirViewController *game1 = [[FirViewController alloc] init];        //test olny
//    game1 =[self.storyboard instantiateViewControllerWithIdentifier:@"game1"];
//    [game1 dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController pushViewController:game1 animated:YES];
//    ThrViewController *game3 = [[ThrViewController alloc] init];        //test olny
//    game3 =[self.storyboard instantiateViewControllerWithIdentifier:@"game3"];
//    [game3 dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController pushViewController:game3 animated:YES];
}

- (IBAction)btnRefresh:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Data.plist"];
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    [_tableV reloadData];
}
-(void)timer{
    [_tableV reloadData];
    remainT -=1;
    
    NSString *key = [[NSString alloc]initWithFormat:@"%ld",selected];                       //is DemoDay?
    NSMutableArray *clockinfo = [NSMutableArray arrayWithArray:[data objectForKey:key]];
    NSString *weekdays = [clockinfo objectAtIndex:4];
    NSString *A = [clockinfo objectAtIndex:3];
    
    if(remainT == 0 && [self isASubString:weekdays subData:@"3"] && [A isEqualToString:@"PM"]){
        NSInteger random = arc4random() %3;
        if(random==0){
            FirViewController *game1 = [[FirViewController alloc] init];
            game1 =[self.storyboard instantiateViewControllerWithIdentifier:@"game1"];
            [game1 dismissViewControllerAnimated:NO completion:nil];
            [self.navigationController pushViewController:game1 animated:YES];
        }
        else if (random==1){
            SecViewController *game2 = [[SecViewController alloc] init];
            game2 =[self.storyboard instantiateViewControllerWithIdentifier:@"game2"];
            [game2 dismissViewControllerAnimated:NO completion:nil];
            [self.navigationController pushViewController:game2 animated:YES];
        }
        else if (random==2){
            ThrViewController *game3 = [[ThrViewController alloc] init];
            game3 =[self.storyboard instantiateViewControllerWithIdentifier:@"game3"];
            [game3 dismissViewControllerAnimated:NO completion:nil];
            [self.navigationController pushViewController:game3 animated:YES];
        }
    }
}
-(void)signClock{
    
    NSString *key = [[NSString alloc]initWithFormat:@"%ld",selected];
    NSMutableArray *clockinfo = [NSMutableArray arrayWithArray:[data objectForKey:key]];
    NSString *H = [[NSString alloc] initWithString:[clockinfo objectAtIndex:1]];
    NSString *M = [[NSString alloc] initWithString:[clockinfo objectAtIndex:2]];
    NSLog(@"%@,%@",H,M);   //target time
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h"];
    NSString *nowH = [dateFormatter stringFromDate:currDate];
    [dateFormatter setDateFormat:@"m"];
    NSString *nowM = [dateFormatter stringFromDate:currDate];
    [dateFormatter setDateFormat:@"s"];
    NSString *nowS = [dateFormatter stringFromDate:currDate];
    
    remainT = (60-[nowS integerValue])*2 + ([M integerValue]-[nowM integerValue]-1)*60*2 + ([H integerValue]-[nowH integerValue])*60*60*2;
    
//    remainT = [M integerValue] - [nowM integerValue];
    
    NSLog(@"%@ %@ %ld",nowH,nowM,remainT);

    
}
-(IBAction)shortcut{
    if(key2==0){
        [player stop];
        FirViewController *game1 = [[FirViewController alloc] init]; //test olny
        game1 =[self.storyboard instantiateViewControllerWithIdentifier:@"game1"];
        [game1 dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController pushViewController:game1 animated:YES];
    }
    key2=1;
}

- (bool)isASubString:(NSString *)a subData:(NSString *)b{
    NSRange range = [a rangeOfString:b];
    if (range.location == NSNotFound) {
        return NO;
    }
    else{
        return YES;
    }
}
@end
