//
//  p2TableViewController.m
//  iOS_alarm
//
//  Created by GuantingLiu on 2018/12/24.
//  Copyright © 2018 Guanting Liu. All rights reserved.
//

#import "p2TableViewController.h"
#import "mycustomcell.h"
@interface p2TableViewController ()
{
    NSArray *weekdays;
    NSArray *sounds;
    NSString *mode;
    NSMutableArray *clockinf;
    NSMutableArray *aSoundsSelected;
    NSMutableArray *aWeekdaySelected;
    mycustomcell *globolCell;
}
@end

@implementation p2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *commit = [[UIBarButtonItem alloc]initWithTitle:@"👌🏻" style:UIBarButtonItemStylePlain target:self action:@selector(commitData:)];
    self.navigationItem.rightBarButtonItem =commit;
    weekdays = [NSArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日",nil];
    sounds = [NSArray arrayWithObjects:@"汪汪",@"喵喵",@"ㄎㄧㄍ", nil];
    aSoundsSelected = [NSMutableArray arrayWithCapacity:[weekdays count]];
    aWeekdaySelected = [NSMutableArray arrayWithCapacity:[sounds count]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"%@",mode);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([mode isEqualToString:@"重複"]) return [weekdays count];
    else if([mode isEqualToString:@"提示聲"]) return [sounds count];
    else return 1;
}
-(id) getSelectedItem:(NSString *)str clockinformation:(NSArray *)clockinfo{
    mode = str;
    clockinf = [NSMutableArray arrayWithArray:clockinfo];
    return self;
}
- (IBAction)commitData:(UIBarButtonItem *)sender {
    NSLog(@"Ok button was tapped: dismiss the view controller.");
    if([mode isEqualToString:@"標籤"]) [clockinf replaceObjectAtIndex:5 withObject:globolCell.mylabel2.text];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);   //save file
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Data.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    [clockinf replaceObjectAtIndex:4 withObject:[self strSorting:[clockinf objectAtIndex:4]]];  //sort weekdays
    
    [data setObject:clockinf forKey:[clockinf objectAtIndex:7]];
    
    [data writeToFile:filePath atomically:YES];
    //unwind clockinfo
    NSLog(@"%@",data);
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerNib:[UINib nibWithNibName:@"Empty" bundle:nil] forCellReuseIdentifier:@"mycell"];//
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(mycustomcell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    globolCell = cell;    //globalize cell to c
    if([mode isEqualToString:@"重複"]){
        cell.mylabel1.text = [weekdays objectAtIndex:indexPath.row];
        [cell.mylabel2 setHidden:YES];
        NSString *str =[[NSString alloc] initWithFormat:@"%ld",indexPath.row+1];
        if([self isASubString:[clockinf objectAtIndex:4] subData:str]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSLog(@"in %ld",indexPath.row);
        }
    }
    else if([mode isEqualToString:@"提示聲"]) {
        cell.mylabel1.text = [sounds objectAtIndex:indexPath.row];
        [cell.mylabel2 setHidden:YES];
        if([[clockinf objectAtIndex:6]isEqualToString:cell.mylabel1.text]) cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        [cell.mylabel1 setHidden:YES];
        cell.mylabel2.text = [clockinf objectAtIndex:5];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    mycustomcell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([mode isEqualToString:@"重複"]){
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSString *numWillRemove = [[NSString alloc]initWithFormat:@"%ld",indexPath.row+1];
            NSString *numNowInclockInfo = [[NSString alloc]initWithString:[clockinf objectAtIndex:4]];
            [clockinf replaceObjectAtIndex:4 withObject:[numNowInclockInfo stringByReplacingOccurrencesOfString:numWillRemove withString:@""]];
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSString *numWillAdd = [[NSString alloc]initWithFormat:@"%ld",indexPath.row+1];
            NSString *numNowInclockInfo = [[NSString alloc]initWithString:[clockinf objectAtIndex:4]];
            [clockinf replaceObjectAtIndex:4 withObject:[numNowInclockInfo stringByAppendingString:numWillAdd]];
        }
        
    }
    else if([mode isEqualToString:@"提示聲"]){
        [clockinf replaceObjectAtIndex:6 withObject:cell.mylabel1.text];
        NSLog(@"%@",clockinf);
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) cell.accessoryType = UITableViewCellAccessoryNone;
        else cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [tableView reloadData];
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
-(NSString *)strSorting:(NSString *)inputData{
    NSString *str = inputData;
    NSMutableArray *charArray = [NSMutableArray arrayWithCapacity:str.length];
    for (int i=0; i<str.length; ++i) {
        NSString *charStr = [str substringWithRange:NSMakeRange(i, 1)];
        [charArray addObject:charStr];
    }
    
    NSString *sortedStr = [[charArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] componentsJoinedByString:@""];
    return sortedStr;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
