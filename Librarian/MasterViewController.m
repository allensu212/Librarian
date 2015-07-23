//
//  ViewController.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "MasterViewController.h"
#import "BookDetailViewController.h"
#import "BookTableViewCell.h"
#import "NetworkManager.h"
#import "NavigationBarLabel.h"
#import "Constants.h"
#import "UIAlertView+Blocks.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *booksDataArray;
@end

@implementation MasterViewController

#pragma mark - LifeCycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self fetchBooks];
    [self configureNav];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchBooks];
}

-(void)configureNav{
    NavigationBarLabel *label = [[NavigationBarLabel alloc]initWithText:@"Books"];
    self.navigationItem.titleView = label;
}

#pragma mark - Networking

-(void)fetchBooks{
    
    [[NetworkManager sharedManager] fetchBooksWithCompletionBlock:^(NSArray *dataArray) {
        self.booksDataArray = [NSMutableArray arrayWithArray:dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *selectedBookDict = self.booksDataArray[indexPath.row];
    BookTableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [bookCell configureCellWithDict:selectedBookDict];
    
    return bookCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.booksDataArray count];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *selectedBookDict = self.booksDataArray[indexPath.row];
        
        [[NetworkManager sharedManager] deleteBook:selectedBookDict[@"url"] withCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.booksDataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }];
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)deleteAllBooks{
    
    [[NetworkManager sharedManager] deleteAllBooksWithCompletionBlock:^(NSArray *dataArray) {
        self.booksDataArray = [NSMutableArray arrayWithArray:dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - IBAction

- (IBAction)deleteAllBooks:(id)sender
{
    UIAlertView *alertView = [UIAlertView showWithTitle:@"Are You Sure?"
                                                message:@"Delete All Books at Once?"
                                      cancelButtonTitle:@"Cencel" otherButtonTitles:@[@"Yes"]
                                               tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self deleteAllBooks];
        }
    }];

    [alertView show];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:SEGUE_DETAIL_IDENTIFIER]) {
        if ([segue.destinationViewController isKindOfClass:[BookDetailViewController class]]) {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
            NSDictionary *selectedBook = self.booksDataArray[indexPath.row];
            BookDetailViewController *detailController = segue.destinationViewController;
            detailController.bookData = selectedBook;
        }
    }
}

@end
