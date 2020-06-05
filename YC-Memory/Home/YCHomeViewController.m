//
//  YCHomeViewController.m
//  YC-Memory
//
//  Created by 黄世文 on 2020/6/3.
//  Copyright © 2020 Swift. All rights reserved.
//

#import "YCHomeViewController.h"
#import "YCHomeTableViewCell.h"
#import "HXSearchBar.h"
#import <SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "ATFMDBTool.h"
#import "YCAcountModel.h"
#import "YCAddViewController.h"
@interface YCHomeViewController ()
<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong)UIImageView *noDataView;

@end

@implementation YCHomeViewController

 -(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
       [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; 
       [self.navigationController.navigationBar setTranslucent:NO];
    [self getData];
     
}
 
- (void)getData{
    NSArray *modelArr = [[ATFMDBTool shareDatabase] at_lookupTable:@"YCMemoryList"
                                                        dicOrModel:[YCAcountModel new]
                                                       whereFormat:@""];
      
      self.dataArray = modelArr.mutableCopy;
      [self.tableView reloadData];
    if (modelArr.count == 0) {
        [SWAlertViewController showInController:self title:@"tips" message:@"Dear user, thank you for using our <YC-Memory App>, go and record your first account management~" cancelButton:@"" other:@"Ok" completionHandler:^(SWAlertButtonStyle buttonStyle) {
            
        }];
        [self.tableView addSubview:self.noDataView];
        
    }else{
        [self.noDataView removeFromSuperview];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIImageView *imgb = [[UIImageView alloc]init];
    [self.view addSubview:imgb];
    imgb.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    imgb. image = kImageName(@"bg2");
    
    
       [self dgiufgwdfewfwe];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight );
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"YCHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 150.f;
    self.tableView.backgroundColor = UIColor.clearColor;
    //[SWKit colorWithHexString:@"#f5f5f5"];
 
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           [self getData];
              [self getData:YES];
          }];
   self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
              [self getData:YES];
          }];
    
}

-(void)dgiufgwdfewfwe{
    UIView * bgViwe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    bgViwe.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgViwe];
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.delegate = self;
    //输入框提示
    searchBar.placeholder = @"Search";
    //TextField
    searchBar.searchBarTextField.layer.cornerRadius = 4;
    searchBar.searchBarTextField.layer.masksToBounds = YES;
    searchBar.searchBarTextField.layer.borderColor = UIColor.grayColor.CGColor;
    searchBar.searchBarTextField.layer.borderWidth = 1.0;
    //清除按钮图标
    searchBar.clearButtonImage = [UIImage imageNamed:@"删除"];
    //去掉取消按钮灰色背景
    searchBar.hideSearchBarBackgroundImage = YES;
    [bgViwe addSubview:searchBar];
    self.tableView.tableHeaderView = searchBar;
    
}

//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    HXSearchBar *sear = (HXSearchBar *)searchBar;
    sear.cancleButton.backgroundColor = [UIColor clearColor];
    [sear.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [sear.cancleButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
}
//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length==0) {
        [self.dataArray removeAllObjects];
        [self getData:NO];
    }
}
//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    NSString *sql = [NSString stringWithFormat:@"where title = '%@'",searchBar.text];
    NSArray *modelArr = [[ATFMDBTool shareDatabase] at_lookupTable:@"YCMemoryList" dicOrModel:[YCAcountModel new] whereFormat:sql];
     [self.view endEditing:YES];
    if (modelArr.count > 0) {
        self.dataArray = [modelArr mutableCopy];
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showErrorWithStatus:@"no Search Data"];
    }
}
//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
    [self getData];
}
-(void)getData:(BOOL)isShowHud{
    if (isShowHud) {
        [SVProgressHUD showWithStatus:@"Loading..."];
        [self performSelector:@selector(dismisss) withObject:nil afterDelay:0.5];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}
- (void)dismisss{
    [SVProgressHUD dismiss];
}


- (UIImageView *)noDataView{
    if (!_noDataView) {
        _noDataView = [UIImageView new];
        _noDataView.frame = CGRectMake((SCREEN_WIDTH - 160)/2, (SCREEN_HEIGHT - 150)/3, 160, 150);
        [_noDataView setImage:kImageName(@"noData")];
    }
    return _noDataView;
}
ATTableViewHeadFooterLineSetting


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YCHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    YCAcountModel *model = self.dataArray[indexPath.section];
    cell.model = model;
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    YCAcountModel * mo = self.dataArray[indexPath.section];
    
    NSString *sql = [NSString stringWithFormat:@"where creatTime = '%@'",mo.creatTime];
  
 
        SWLog(@"");
        [SWAlertViewController showInController:self title:@"Tips" message:@"Are you sure you want to delete this password management?" cancelButton:@"cancel" other:@"Sure" completionHandler:^(SWAlertButtonStyle buttonStyle) {
            if (buttonStyle == SWAlertButtonStyleOK) {
                BOOL isSuccess =  [[ATFMDBTool shareDatabase] at_deleteTable:@"YCMemoryList" whereFormat:sql];
                  if (isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:@"delete Success"]; 
                        [self.dataArray removeObjectAtIndex:indexPath.section];
                        [tableView reloadData];
                      }
            }
        }];
        
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YCAddViewController *vc = [YCAddViewController new];
    vc.model = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
 

@end
