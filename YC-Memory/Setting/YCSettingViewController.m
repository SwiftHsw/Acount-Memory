//
//  YCSettingViewController.m
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import "YCSettingViewController.h"
#import "ATFMDBTool.h"
#import "YCAcountModel.h"
#import <SVProgressHUD.h>
#import "sssuhofViewController.h"
#import "ushaohohoihioViewController.h"

@interface YCSettingViewController ()
<UITableViewDelegate,UITableViewDataSource>
@end

@implementation YCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
   self.dataArray = @[@[@"Category management"],@[@"About us",@"Current version",@"To Socre",@"Share Friend"],@[@"Export all"]].mutableCopy;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
     [self.view addSubview:self.tableView];
    
}
#pragma mark tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dataArray .count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr =  self.dataArray[section];
    return arr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =  self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.font = kFontWithSize(16);
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.detailTextLabel.text = GETSYSTEM;
        cell.selectionStyle = UITableViewCellStyleDefault;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

ATTableViewHeadFooterLineSetting

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
         NSArray *modelArr = [[ATFMDBTool shareDatabase]
                              at_lookupTable:@"YCMemoryList"
                              dicOrModel:[YCAcountModel new]
                              whereFormat:@""];
        
             [SVProgressHUD showWithStatus:@"Loading..."];
            
            NSString * finalStr = @"";
            for (YCAcountModel * mo in modelArr) {
                SWLog(@"%@",finalStr);
                if (finalStr.length==0) {
                    finalStr = [NSString stringWithFormat:@"title：%@\nType：%@\nTag：%@\nAccount：%@\nPassword：%@ ",mo.title,mo.category,mo.tagStr,mo.account,mo.password ];
                }else{
                    finalStr = [NSString stringWithFormat:@"%@\ntitle：%@\nType：%@\nTag：%@\nAccount：%@\nPassword：%@ ",finalStr,mo.title,mo.category,mo.tagStr,mo.account,mo.password ];
                }
            }
            UIPasteboard * board = [UIPasteboard generalPasteboard];
            board.string = finalStr;
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5];
        
        
    }
    
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[sssuhofViewController new] animated:YES];
    }
  if (indexPath.section == 1) {
             NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",@""];
      if (indexPath.row == 0) {
          [self.navigationController pushViewController:[ushaohohoihioViewController new] animated:YES];
      }
 
      if (indexPath.row == 2) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
      }
      if (indexPath.row == 3) {
          [self yc_shareWithTitle:@"YC-Memory" image:kImageName(@"logo") url:str target:self complete:^(BOOL isSuccess, UIActivityType type) {
              
          }];
      }
     }
    
}
- (void)delayMethod{
    
    [SVProgressHUD showSuccessWithStatus:@"Export succeeded, copied to pasteboard"];
}
- (void)yc_shareWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url target:(UIViewController *)target complete:(void (^)(BOOL isSuccess, UIActivityType type))complete
{
    // 分享内容
    NSString *shareTitle = title;
    UIImage *shareImage = image;
    NSURL *shareUrl = [NSURL URLWithString:url];
    NSArray *activityItemsArray = @[shareTitle, shareImage, shareUrl];
    //
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItemsArray applicationActivities:nil];
    activityVC.modalInPopover = YES;
    // 禁用分享渠道
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (complete) {
            complete(completed, activityType);
        }
    };
    [target presentViewController:activityVC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
