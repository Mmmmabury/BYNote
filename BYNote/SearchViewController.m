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
#import "CoreDataManager.h"
#import "Note.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *searchResultTableView;
@property (strong, nonatomic) NSArray *localNotes;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
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
    
    if (searchText.length == 0) {
        
        _localNotes = nil;
        [_searchResultTableView reloadData];
        return;
    }
    // 获取笔记
    NSManagedObjectContext *context = [[CoreDataManager shareCoreDataManager] managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
    NSString *format = [NSString stringWithFormat:@"content like '*%@*'", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    NSLog(@"%@", predicate.predicateFormat);
    fetch.predicate = predicate;
    _localNotes = [context executeFetchRequest:fetch error:nil];
    [_searchResultTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [_searchBar resignFirstResponder];
}

# pragma mark tableView 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Note *note = _localNotes[indexPath.row];
    cell.textLabel.text = note.content;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _localNotes.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

@end
