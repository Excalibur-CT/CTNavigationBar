
//
//  AlphaController.m
//  CTNavigationBar
//
//  Created by Admin on 2016/12/18.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "AlphaController.h"
#import "CTNavigationBar.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface AlphaController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)CTNavigationBar * navigationBar;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AlphaController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navigationBar];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.navigationBar ct_barAlphaDidScroll:scrollView maxOffsetY:64];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

- (CTNavigationBar *)navigationBar
{
    if (_navigationBar == nil) {
        _navigationBar = [[CTNavigationBar alloc] initWithTitle:@"Alpha"];
        _navigationBar.barAlpha = 0;
        _navigationBar.isTitleLucid = YES;
        __weak typeof(self) weakSelf = self;
        [_navigationBar ct_setLeftButtonImage:[UIImage imageNamed:@"nav_back"] actionBlock:^(CTNavigationBar * bar,UIBarButtonItem *item) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];        
    }
    return _navigationBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIImageView * img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0001"]];
        img.frame = CGRectMake(0, 0, size.width, 200);
        _tableView.tableHeaderView = img;
        
    }
    return _tableView;
}


@end
