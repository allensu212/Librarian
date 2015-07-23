//
//  AddBookViewController.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "AddBookViewController.h"
#import "Book.h"
#import "NavigationBarLabel.h"
#import "NetworkManager.h"
#import "SVProgressHUD.h"
#import "UIAlertView+Blocks.h"

typedef enum : NSInteger {
    INFO_BOOK_TITLE =0,
    INFO_BOOK_AUTHOR = 1,
    INFO_BOOK_PUBLISHER = 2,
    INFO_BOOK_CATEGORIES = 3,
} NewBookInfoType;

@interface AddBookViewController () <UITextFieldDelegate>
@property (nonatomic, strong) Book *book;
@end

@implementation AddBookViewController{
    BOOL _isEditing;
}

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
    [self configureNav];
    _isEditing = NO;
}

-(void)configureNav{
    NavigationBarLabel *label = [[NavigationBarLabel alloc]initWithText:@"Add Book"];
    self.navigationItem.titleView = label;
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
    return [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
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
    
    _isEditing = YES;
    
    return YES;
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
                _isEditing = NO;
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
        [SVProgressHUD showWithStatus:@"Adding" maskType:SVProgressHUDMaskTypeGradient];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops"
                                                           message:@"Please enter Book Title and Author"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)done:(id)sender
{
    [self validateTextFieldContent];
}

-(void)validateTextFieldContent
{
    if (_isEditing)
    {
        [UIAlertView showWithTitle:@"Are You Sure?" message:@"Leave the Screen with Unsaved Changes?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
