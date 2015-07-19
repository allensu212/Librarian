//
//  AddBookViewController.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "AddBookViewController.h"
#import "NetworkManager.h"
#import "SVProgressHUD.h"
#import "Book.h"

typedef enum : NSInteger {
    INFO_BOOK_TITLE =0,
    INFO_BOOK_AUTHOR =1,
    INFO_BOOK_PUBLISHER = 2,
    INFO_BOOK_CATEGORIES = 3,
} NewBookInfoType;

@interface AddBookViewController () <UITextFieldDelegate>
@property (nonatomic, strong) Book *book;
@end

@implementation AddBookViewController

#pragma mark - LazyInstantiation

-(Book *)book{
    if (!_book) {
        _book = [[Book alloc]init];
    }
    return _book;
}

#pragma mark - LifeCycle

-(void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NewBookInfoType infoType = textField.tag;
    
    switch (infoType) {
        case INFO_BOOK_TITLE:
            self.book.bookTitle = textField.text;
            break;
        case INFO_BOOK_AUTHOR:
            self.book.author = textField.text;
            break;
        case INFO_BOOK_PUBLISHER:
            self.book.publisher = textField.text;
            break;
        case INFO_BOOK_CATEGORIES:
            self.book.categories = textField.text;
            break;
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NewBookInfoType infoType = textField.tag;
    
    switch (infoType) {
        case INFO_BOOK_TITLE:
            self.book.bookTitle = textField.text;
            break;
        case INFO_BOOK_AUTHOR:
            self.book.author = textField.text;
            break;
        case INFO_BOOK_PUBLISHER:
            self.book.publisher = textField.text;
            break;
        case INFO_BOOK_CATEGORIES:
            self.book.categories = textField.text;
            break;
        default:
            break;
    }
    return [textField resignFirstResponder];
}

#pragma mark - IBAction

- (IBAction)submitNewBook:(id)sender
{
    if (self.book.bookTitle != nil && self.book.author != nil)
    {
        NetworkManager *networkManager = [NetworkManager sharedManager];
        
        [networkManager addNewBook:self.book withCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }];
        [SVProgressHUD showWithStatus:@"Adding"];
    }
    else
    {
        //handling error...
    }
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
