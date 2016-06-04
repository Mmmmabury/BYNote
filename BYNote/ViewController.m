//
//  ViewController.m
//  BYNote
//
//  Created by cby on 16/5/24.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ViewController.h"
#import "BYNCollectionFlowView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view, typically from a nib.
    BYNCollectionFlowView *collectionView = [[BYNCollectionFlowView alloc] initWithFrame:self.view.bounds];
    collectionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:collectionView];
    self.navigationController.navigationBarHidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
