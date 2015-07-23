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

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *booksDataArray;
@property (nonatomic, strong) NetworkManager *networkManager;
@end

@implementation MasterViewController

#pragma mark - LazyInstantiation

-(NetworkManager *)networkManager{
    if (!_networkManager) {
        _networkManager = [NetworkManager sharedManager];
    }
    return _networkManager;
}

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
    
    [self.networkManager fetchBooksWithCompletionBlock:^(NSArray *dataArray) {
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
    
    bookCell.spinner.hidden = NO;
    [bookCell.spinner startAnimating];
    
    [self.networkManager fetchBookCoverWithBookTitle:selectedBookDict[@"title"] withCompletionBlock:^(NSString *coverURL, NSDictionary *jsonDict) {
        
        NSURL * imageURL = [NSURL URLWithString:coverURL];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            bookCell.coverImageView.image = [UIImage imageWithData:imageData];;
            [bookCell.spinner stopAnimating];
            bookCell.spinner.hidden = YES;
            [bookCell configureCellWithDict:selectedBookDict];
        });
    }];
    
    return bookCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.booksDataArray count];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *selectedBookDict = self.booksDataArray[indexPath.row];
        
        [self.networkManager deleteBook:selectedBookDict[@"url"] withCompletionBlock:^{
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

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteAllBooks];
    }
}

-(void)deleteAllBooks{
    
    [self.networkManager deleteAllBooksWithCompletionBlock:^(NSArray *dataArray) {
        self.booksDataArray = [NSMutableArray arrayWithArray:dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - IBAction

- (IBAction)deleteAllBooks:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Are You Sure?" message:@"Delete all books at once?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
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
