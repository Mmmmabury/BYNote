//
//  SearchViewController.m
//  BYNote
//
//  Created by cby on 16/6/21.
//  Copyright © 2016年 cby. All rights reserved.
//

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#import "SearchViewController.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *searchResultTableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
    
    self.navigationController.navigationBarHidden = NO;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.placeholder = NSLocalizedString(@"searchBarPlaceHolder", nil);
    [self.view addSubview:_searchBar];
    
    _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114) style:UITableViewStylePlain];
    [self.view addSubview:_searchResultTableView];
    _searchResultTableView.delegate = self;
    _searchResultTableView.dataSource = self;
    [_searchResultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

# pragma mark searchBar 代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [_searchBar resignFirstResponder];
}

# pragma mark tableView 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"hh";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

@end
