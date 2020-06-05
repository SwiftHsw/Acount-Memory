


//
//  YCTabbarViewController.m
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import "YCTabbarViewController.h"
#import "YCAddViewController.h"
#import "YCHomeViewController.h"
#import "YCSettingViewController.h"

@interface YCTabbarViewController ()

@end

@implementation YCTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YCHomeViewController *home = [YCHomeViewController new];
    [self setupChildVc:home
                 title:@"List" image:@"list_n" selectedImage:@"list_s" normalColor:UIColor.grayColor selectColor:[UIColor.blueColor colorWithAlphaComponent:.8]];
    
    YCAddViewController *add = [YCAddViewController new];
     [self setupChildVc:add
                  title:@"Add" image:@"add_n" selectedImage:@"add_s" normalColor:UIColor.grayColor selectColor:[UIColor.blueColor colorWithAlphaComponent:.8]];
    
    YCSettingViewController *setting = [YCSettingViewController new];
     [self setupChildVc:setting
                  title:@"Setting" image:@"setting_n" selectedImage:@"setting_s" normalColor:UIColor.grayColor selectColor:[UIColor.blueColor colorWithAlphaComponent:.8]];
    
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
