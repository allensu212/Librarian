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

-(Book *)book{
    if (!_book) {
        _book = [[Book alloc]init];
        _book.url = self.currentBookDict[@"url"];
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
    
    NavigationBarLabel *label;
    
    if (self.updatingBookInfo) {
        label = [[NavigationBarLabel alloc]initWithText:@"Edit Book"];
        [self.actionButton setTitle:@"Update" forState:UIControlStateNormal];
        
        [self fillOutTextFieldsWithBookDict:self.currentBookDict];

    }else {
        label = [[NavigationBarLabel alloc]initWithText:@"Add Book"];
        [self.actionButton setTitle:@"Submit" forState:UIControlStateNormal];
    }
    
    self.navigationItem.titleView = label;
}

-(void)fillOutTextFieldsWithBookDict:(NSDictionary *)bookDict{
    self.bookTitleTextField.text = bookDict[@"title"];
    self.authorTextField.text = bookDict[@"author"];
    self.publisherTextField.text = bookDict[@"publisher"];
    self.categoriesTextField.text = bookDict[@"categories"];
    self.book.bookTitle = self.bookTitleTextField.text;
    self.book.author = self.authorTextField.text;
    self.book.publisher = self.publisherTextField.text;
    self.book.categories = self.categoriesTextField.text;
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
    if (self.updatingBookInfo) {
        [self updateBookInformation];
    }else {
        [self addNewBook];
    }
}

-(void)addNewBook{
    
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

-(void)updateBookInformation{
    
    [[NetworkManager sharedManager]updateBookInfo:self.book withCompletionBlock:^(NSDictionary *dataDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate userDidUpdateBookInformationWithDict:dataDict];
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD showWithStatus:@"Updating" maskType:SVProgressHUDMaskTypeGradient];
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
