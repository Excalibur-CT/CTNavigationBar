//
//  GradController.m
//  CTNavigationBar
//
//  Created by Admin on 2017/2/22.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "GradController.h"
#import "CTNavigationBar.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface GradController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)CTNavigationBar * navigationBar;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation GradController

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
    [self.navigationBar ct_colorGradDidScroll:scrollView toColor:[UIColor blueColor] maxOffSetY:100 progressBlock:^(CTNavigationBar *bar, CGFloat ratio) {
        if (ratio < 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            bar.tintColor = [UIColor whiteColor];
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            bar.tintColor = [UIColor blackColor];
        }
    }];
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
        _navigationBar = [[CTNavigationBar alloc] initWithTitle:@"ColorGrad"];
        __weak typeof(self) weakSelf = self;
        _navigationBar.backgroundColor = [UIColor redColor];
        _navigationBar.tintColor = [UIColor whiteColor];
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
