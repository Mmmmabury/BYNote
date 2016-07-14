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
#import "BYNCollectionFlowView.h"

@interface SearchViewController () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) BYNCollectionFlowView *flowView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self createSubViews];
}

- (void)createSubViews{
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.placeholder = NSLocalizedString(@"searchBarPlaceHolder", nil);
    [self.view addSubview:_searchBar];
    
    _flowView = [[BYNCollectionFlowView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114) andType:-1];
    [self.view addSubview:_flowView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (self.navigationController.isNavigationBarHidden) {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

# pragma mark searchBar 代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        
        _flowView.localNotes = nil;
        [_flowView reloadData];
        return;
    }
    if (!searchBar.showsCancelButton) {
        
        searchBar.showsCancelButton = YES;
    }
    // 获取笔记
    NSManagedObjectContext *context = [[CoreDataManager shareCoreDataManager] managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
    NSString *format = [NSString stringWithFormat:@"content like '*%@*'", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    fetch.predicate = predicate;
    _flowView.localNotes = [context executeFetchRequest:fetch error:nil];
    [_flowView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [_searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}
@end
