

//
//  sssuhofViewController.m
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/4.
//  Copyright © 2020 Swift. All rights reserved.
//

#import "sssuhofViewController.h"
#import "YCAcountModel.h"
#import "ATFMDBTool.h"
#import <SVProgressHUD.h>

@interface sssuhofViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation sssuhofViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavEnable:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Category management";
     self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem
                                                 itemWithImageName:@"selectButton"
                                                 selectedImageName:@"selectButton"
                                                 target:self
                                                 action:@selector(rightNavBtnClick)];
    [self.view addSubview:self.tableView];
    [self getData];
}
-(void)getData{
     NSArray *modelArr = [[ATFMDBTool shareDatabase]
                          at_lookupTable:@"CategoryList"
                          dicOrModel:[YCCategoryModel new]
                          whereFormat:@""]; 
    if (modelArr.count == 0) {
          [SWAlertViewController showInController:self title:@"tips" message:@"You can add more categories to choose. Go and add categories!" cancelButton:@"" other:@"Ok" completionHandler:^(SWAlertButtonStyle buttonStyle) {
              
          }];
          [self.tableView addSubview:self.noDataView];
          
      }else{
          [self.noDataView removeFromSuperview];
      }
    
     self.dataArray=modelArr.mutableCopy;
  
    [self.tableView reloadData];
}
 
-(void)rightNavBtnClick{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"New category" message:@"Enter the category name you want to add" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Determine" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *modelArr = [[ATFMDBTool shareDatabase]
        at_lookupTable:@"CategoryList"
        dicOrModel:[YCCategoryModel new]
        whereFormat:@""];
        if (modelArr.count == 10) {
            [SVProgressHUD showErrorWithStatus:@"Add up to 10 categories！"];
            return ;
        }
        NSArray * textfields = alert.textFields;
        UITextField * passwordfiled = textfields[0];
        if (kStringIsEmpty(passwordfiled.text)) {
            [SVProgressHUD showErrorWithStatus:@"Please enter your category and add"];
            return;
        }
        YCCategoryModel * mo  = [YCCategoryModel new];
        mo.category = passwordfiled.text;
       [[ATFMDBTool shareDatabase] at_insertTable:@"CategoryList" dicOrModel:mo];
        [self getData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    YCCategoryModel * mo = self.dataArray[indexPath.row];
    cell.textLabel.text = mo.category;
    return cell;
}
 
 -(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
     return @"Delete";
 }
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YCCategoryModel * mo = self.dataArray[indexPath.section];
       NSString *sql = [NSString stringWithFormat:@"where category = '%@'",mo.category];
       [self.dataArray removeObjectAtIndex:indexPath.section];
           SWLog(@"");
           [SWAlertViewController showInController:self title:@"Tips" message:@"Are you sure you want to delete this category?" cancelButton:@"cancel" other:@"Sure" completionHandler:^(SWAlertButtonStyle buttonStyle) {
               if (buttonStyle == SWAlertButtonStyleOK) {
                   BOOL isSuccess =  [[ATFMDBTool shareDatabase] at_deleteTable:@"CategoryList" whereFormat:sql];
                     if (isSuccess) {
                           [SVProgressHUD showSuccessWithStatus:@"delete Success"];
                           [tableView reloadData];
                         }
               }
           }];
    
}

#pragma mark - lazy

 - (UIImageView *)noDataView{
     if (!_noDataView) {
         _noDataView = [UIImageView new];
         
         _noDataView.frame = CGRectMake((SCREEN_WIDTH - 150)/2, (SCREEN_HEIGHT - 150)/3, 150, 150);
          [_noDataView setImage:kImageName(@"noData")];
     }
     return _noDataView;
 }
@end
