//
//  ViewController.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "MasterViewController.h"
#import "BookTableViewCell.h"
#import "NetworkManager.h"
#import "Constants.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *booksDataArray;
@property (nonatomic, strong) NetworkManager *networkManager;

@end

@implementation MasterViewController

#pragma mark - LazyInstantiation

-(NetworkManager *)networkManager{
    if (!_networkManager) {
        _networkManager = [[NetworkManager alloc]init];
    }
    return _networkManager;
}

-(NSArray *)booksDataArray{
    if (!_booksDataArray) {
        _booksDataArray = [[NSArray alloc]init];
    }
    return _booksDataArray;
}

#pragma mark - LifeCycle

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self fetchBooks];
}

#pragma mark - Networking

-(void)fetchBooks{
    [self.networkManager fetchBooksWithCompletionBlock:^(NSArray *dataArray) {
        self.booksDataArray = dataArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *selectedBookDict = self.booksDataArray[indexPath.row];
    BookTableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
    [bookCell configureCellWithDict:selectedBookDict];
    
    return bookCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_booksDataArray count];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
