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
#import "Book.h"
#import "AddBookViewController.h"
#import "UIAlertView+Blocks.h"
#import <QuartzCore/QuartzCore.h>

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addBookButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *booksDataArray;
@end

@implementation MasterViewController{
    BOOL _isLoading;
}

#pragma mark - LifeCycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configureUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchBooks];
}

#pragma mark - UIUpdate

-(void)configureUI{
    NavigationBarLabel *label = [[NavigationBarLabel alloc]initWithText:@"Books"];
    self.navigationItem.titleView = label;
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
    
    self.addBookButton.layer.cornerRadius = self.addBookButton.frame.size.width / 2;
    self.addBookButton.layer.shadowColor = [[UIColor darkGrayColor]CGColor];
    self.addBookButton.layer.shadowOpacity = 0.7f;
    self.addBookButton.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.addBookButton.layer.shadowRadius = 4.0f;
    self.addBookButton.layer.shouldRasterize = YES;
    
    UINib *loadingCellNib = [UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    [self.tableView registerNib:loadingCellNib forCellReuseIdentifier:LoadingCellIdentifier];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        [self.tableView setEditing:YES animated:YES];
    }else{
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark - Networking

-(void)fetchBooks{
    
    [[NetworkManager sharedManager]fetchBooksWithCompletionBlock:^(NSMutableArray *booksArray) {
        [self.booksDataArray removeAllObjects];
        self.booksDataArray = booksArray;
        _isLoading = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    _isLoading = YES;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isLoading) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:100];
        cell.userInteractionEnabled = NO;
        [spinner startAnimating];
        return cell;
        
    }else{
        Book *selectedBook = self.booksDataArray[indexPath.row];
        BookTableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
        [bookCell configureCellWithBook:selectedBook];
        
        return bookCell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isLoading) {
        return 1;
    }else{
        return [self.booksDataArray count];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Book *selectedBook = self.booksDataArray[indexPath.row];
        
        [[NetworkManager sharedManager] deleteBook:selectedBook withCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.booksDataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }];
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isLoading) {
        return self.view.frame.size.height;
    }else{
        return CELL_HEIGHT;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(void)deleteAllBooks{
    
    [[NetworkManager sharedManager] deleteAllBooksWithCompletionBlock:^(NSArray *dataArray) {
        self.booksDataArray = [NSMutableArray arrayWithArray:dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:SEGUE_DETAIL_IDENTIFIER]) {
        if ([segue.destinationViewController isKindOfClass:[BookDetailViewController class]]) {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
            Book *selectedBook = self.booksDataArray[indexPath.row];
            BookDetailViewController *detailController = segue.destinationViewController;
            detailController.bookToShow = selectedBook;
        }
    }
}

@end
