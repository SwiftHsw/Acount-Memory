//
//  AppDelegate.m
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import "AppDelegate.h"
#import <SWKit.h>
#import "YCTabbarViewController.h"
#import "ATFMDBTool.h"
#import "YCAcountModel.h"
#import <SVProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.i
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyWindow];
    self.window.rootViewController = [YCTabbarViewController new];
    
    //创建文件夹,初始化数据库
     [SWKit creatFile:[NSString stringWithFormat:@"userData/%@",@"YCMemory"] filePath:ATDocumentPath];
    //账号管理表格
    [[ATFMDBTool shareDatabase] at_createTable:@"YCMemoryList" dicOrModel:[YCAcountModel new]];
    //Category management
      [[ATFMDBTool shareDatabase] at_createTable:@"CategoryList" dicOrModel:[YCCategoryModel new]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    
    return YES;
}


//#pragma mark - UISceneSession lifecycle
//
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
