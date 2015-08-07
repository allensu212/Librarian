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
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextField *bookTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UITextField *publisherTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoriesTextField;
@end

@implementation AddBookViewController{
    BOOL _isEditing;
}

#pragma mark - LazyInstantiation

-(Book *)currentBook{
    if (!_currentBook) {
        _currentBook = [[Book alloc]init];
    }
    return _currentBook;
}

#pragma mark - LifeCycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configureNav];
    _isEditing = NO;
}

-(void)configureNav{
    
    NavigationBarLabel *label;
    
    if (self.updatingBookInfo) {
        label = [[NavigationBarLabel alloc]initWithText:@"Edit Book"];
        [self.actionButton setTitle:@"Update" forState:UIControlStateNormal];
        
        [self fillOutTextFieldsWithBook:self.currentBook];

    }else {
        label = [[NavigationBarLabel alloc]initWithText:@"Add Book"];
        [self.actionButton setTitle:@"Submit" forState:UIControlStateNormal];
    }
    
    self.navigationItem.titleView = label;
}

-(void)fillOutTextFieldsWithBook:(Book *)book{
    
    NSString *formattedPublisherString = [book.publisher isEqualToString:@"(null)"] ? @"Default": book.publisher;
    NSString *formattedCategoriesString = [book.categories isEqualToString:@"(null)"] ? @"Default": book.categories;
    self.bookTitleTextField.text = book.bookTitle;
    self.authorTextField.text = book.author;
    self.publisherTextField.text = formattedPublisherString;
    self.categoriesTextField.text = formattedCategoriesString;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NewBookInfoType infoType = textField.tag;
    
    switch (infoType) {
        case INFO_BOOK_TITLE:
            self.currentBook.bookTitle = textField.text;
            break;
        case INFO_BOOK_AUTHOR:
            self.currentBook.author = textField.text;
            break;
        case INFO_BOOK_PUBLISHER:
            self.currentBook.publisher = textField.text;
            break;
        case INFO_BOOK_CATEGORIES:
            self.currentBook.categories = textField.text;
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
            self.currentBook.bookTitle = textField.text;
            break;
        case INFO_BOOK_AUTHOR:
            self.currentBook.author = textField.text;
            break;
        case INFO_BOOK_PUBLISHER:
            self.currentBook.publisher = textField.text;
            break;
        case INFO_BOOK_CATEGORIES:
            self.currentBook.categories = textField.text;
            break;
        default:
            break;
    }
    
    _isEditing = YES;
    
    return YES;
}

#pragma mark - ManagingBooks

-(void)manageBook{
    
    if (self.currentBook.bookTitle != nil && self.currentBook.author != nil && ![self.currentBook.bookTitle isEqualToString:@""] && ![self.currentBook.author isEqualToString:@""])
    {
        if (self.updatingBookInfo) {
            [self updateBookInformation];
        }else {
            [self addNewBook];
        }
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

#pragma mark - Networking

-(void)addNewBook{
    
    [[NetworkManager sharedManager] addNewBook:self.currentBook withCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            _isEditing = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD showWithStatus:@"Adding" maskType:SVProgressHUDMaskTypeGradient];
}

-(void)updateBookInformation{
    
    [[NetworkManager sharedManager]updateBookInfo:self.currentBook withCompletionBlock:^(Book *updatedBook) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate userDidUpdateBookInformationWithDict:updatedBook];
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD showWithStatus:@"Updating" maskType:SVProgressHUDMaskTypeGradient];
}

#pragma mark - IBAction

- (IBAction)submitNewBook:(id)sender
{
    [self manageBook];
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
