
//
//  YCAddViewController.m
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import "YCAddViewController.h"
#import "YCAddRecordCell.h"
#import "YCAcountModel.h"
#import <SDAutoLayout.h>
#import "ATFMDBTool.h"
#import <SVProgressHUD.h>
#import "LPActionSheet.h"
@interface YCAddViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _titleArr,*_valueArr;
    NSMutableDictionary * _paraDic;
    NSString *_oldPassword;
}
@end

@implementation YCAddViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
       [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  
       [self.navigationController.navigationBar setTranslucent:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _paraDic = [NSMutableDictionary new];
    self.navigationItem.title =_model ?  @"Modify":@"Add new account";
    _titleArr = @[@"Title:",@"Type:",@"Tag:",@"Account:",@"Password:",@"Confirm password:"];
    
    //change Model
    if (self.model) {
        _oldPassword = self.model.password;
        
        _valueArr = @[self.model.title,self.model.category,self.model.tagStr,self.model.account,self.model.password,self.model.password];
        NSArray * keyArr = @[@"title",@"category",@"tagStr",@"account",@"password",@"verifyPassword"];
        for (int i=0;i<keyArr.count;i++) {
            [_paraDic setValue:_valueArr[i] forKey: keyArr[i]];
        }
    }
    
    UIImageView *imgb = [[UIImageView alloc]init];
    [self.view addSubview:imgb];
    imgb.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    imgb. image = kImageName(@"bg");
    kImageContenMode(imgb);
     
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70.f;
    self.tableView.backgroundColor = UIColor.clearColor; 
    [self.view addSubview:self.tableView];
    [self createBottomBtn];
    self.navigationItem.rightBarButtonItem =[ UIBarButtonItem itemWithImageName:@"save" selectedImageName:@"save" target:self action:@selector(saveAdd)];
      
    
}
-(void)createBottomBtn{

    UIButton * botBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [botBtn setTitle:@"Generate Password" forState:UIControlStateNormal];
      [botBtn addTarget:self action:@selector(botBtnClick) forControlEvents:UIControlEventTouchUpInside];
      botBtn.frame = CGRectMake(30, SCREEN_HEIGHT- 80 - TabbarHeight - NavBarHeight, SCREEN_WIDTH-60, 69);
      [self.view addSubview:botBtn];
    [botBtn setBackgroundImage:kImageName(@"组 1") forState:UIControlStateNormal];
    
    
}
-(void)botBtnClick{
    
    NSIndexPath *idxPassword=[NSIndexPath indexPathForRow:0 inSection:4];
           YCAddRecordCell * cellPwd = [self.tableView cellForRowAtIndexPath:idxPassword];
           cellPwd.inputTF.text = @"";
           NSIndexPath *idxVPassword=[NSIndexPath indexPathForRow:0 inSection:5];
           YCAddRecordCell * cellVPwd = [self.tableView cellForRowAtIndexPath:idxVPassword];
           cellVPwd.inputTF.text = @"";
    
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        NSString * str = [self return16LetterAndNumber];
        [self->_paraDic setObject:str forKey:@"password"];
        [self->_paraDic setObject:str forKey:@"verifyPassword"];
               NSIndexPath *idxPassword=[NSIndexPath indexPathForRow:0 inSection:4];
               YCAddRecordCell * cellPwd = [self.tableView cellForRowAtIndexPath:idxPassword];
               cellPwd.inputTF.text = str;
               NSIndexPath *idxVPassword=[NSIndexPath indexPathForRow:0 inSection:5];
               YCAddRecordCell * cellVPwd = [self.tableView cellForRowAtIndexPath:idxVPassword];
               cellVPwd.inputTF.text = str;
    });
       
}

- (void)saveAdd{
    NSArray * keyArr = @[@"title",@"account",@"password",@"verifyPassword"];
           NSArray * alertArr = @[@"Please enter the title",@"Please enter the account",@"Please enter the password",@"Please enter the password again"];
           __block BOOL isgoOn = YES;
           [keyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               NSString * value = self->_paraDic[obj];
               if (value.length==0) {
                   [SVProgressHUD showErrorWithStatus:alertArr[idx]];
                   isgoOn = NO;
                   *stop = YES;
               }
           }];
           if (!isgoOn) {
               return;
           }
           NSString * pwd = _paraDic[@"password"];
           NSString * vPwd = _paraDic[@"verifyPassword"];
           if (![pwd isEqualToString:vPwd]) {
                [SVProgressHUD showErrorWithStatus:@"Two passwords are inconsistent" ];
               return;
           }
           YCAcountModel * mo = [YCAcountModel new];
           mo.title = _paraDic[@"title"];
           mo.category = _paraDic[@"category"]?_paraDic[@"category"]:@"";
           mo.tagStr = _paraDic[@"tagStr"]?_paraDic[@"tagStr"]:@"";
           mo.account = _paraDic[@"account"];
           mo.password = _paraDic[@"password"];
           NSString *time= [NSDate getNowTimeTimestamp3];
           mo.creatTime =time;
           if (self.model) {
               //change
               self.model = mo;
               NSString *sql = [NSString stringWithFormat:@"where password = '%@'",_oldPassword];
            BOOL isSuccess =   [[ATFMDBTool shareDatabase] at_updateTable:@"YCMemoryList" dicOrModel:self.model whereFormat:sql];
               if (isSuccess) {
                   [SVProgressHUD showSuccessWithStatus:@"Change Success"];
                                [self back];
               }else{
                   [SVProgressHUD showErrorWithStatus:@"change error"];
               }
              
           }else{
                [SVProgressHUD showSuccessWithStatus:@"Add Success"];
                [[ATFMDBTool shareDatabase] at_insertTable:@"YCMemoryList" dicOrModel:mo];
                SWLog(@"保存成功");
               _paraDic = [NSMutableDictionary dictionary];
                   for (UITableViewCell *cell in self.tableView.visibleCells ) {
                       if ([cell isKindOfClass:[YCAddRecordCell class]]) {
                           [(YCAddRecordCell *)cell inputTF].text = @"";
                       }else{
                           cell.detailTextLabel.text = @"";
                       }
                   }
                   [self.tableView reloadData];
           }
     
      
}
ATTableViewHeadFooterLineSetting

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
        YCAddRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
         cell.backgroundColor = UIColor.clearColor;
        if(!cell){
            cell = [[YCAddRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.titleLab.text = _titleArr[indexPath.section];
            if (indexPath.section==4||indexPath.section==5) {
                cell.inputTF.secureTextEntry = YES;
            }
        }
        if (indexPath.section == 1) {
            cell.accessoryView = [SWKit getAccessoryImage];
            cell.inputTF.userInteractionEnabled = NO;
        }
        if (self.model) {
            cell.inputTF.text = _valueArr[indexPath.section];
        }
        cell.inputBlock = ^(NSString *str) {
            switch (indexPath.section) {
                case 0:[self->_paraDic setValue:str forKey:@"title"];break;
                case 2:[self->_paraDic setValue:str forKey:@"tagStr"];break;
                case 3:[self->_paraDic setValue:str forKey:@"account"];break;
                case 4:[self->_paraDic setValue:str forKey:@"password"];break;
                case 5:[self->_paraDic setValue:str forKey:@"verifyPassword"];break;
                default:
                    break;
            }
        };
        return cell;
}
 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        [self.view endEditing:YES];
        NSMutableArray *muta = [NSMutableArray array];
        NSArray *modelArr = [[ATFMDBTool shareDatabase]
                               at_lookupTable:@"CategoryList"
                               dicOrModel:[YCCategoryModel new]
                               whereFormat:@""];
        for (YCCategoryModel *model in modelArr) {
            [muta addObject:model.category];
        }
        [LPActionSheet showActionSheetWithTitle:@"Tips" cancelButtonTitle:@"cancel" destructiveButtonTitle:(modelArr.count == 0 ) ? @"Go to settings to add":@"" otherButtonTitles:muta handler:^(LPActionSheet *actionSheet, NSInteger index) {
            if (index >= 1) {
                NSString *str = muta[index-1];
               YCAddRecordCell * cell = [tableView cellForRowAtIndexPath:indexPath];
               cell.inputTF.text = str;
               [self->_paraDic setObject:str forKey:@"category"];
            }else if(index == -1){
                self.tabBarController.selectedIndex = 2;
            }
        }];
    }
}
 
//返回16位大小写字母和数字
-(NSString *)return16LetterAndNumber{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:16];
    for (int i = 0; i < 16; i++){
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    return result;
}
@end

