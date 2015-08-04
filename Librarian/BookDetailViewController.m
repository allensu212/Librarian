//
//  BookDetailViewController.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "BookDetailViewController.h"
#import "NetworkManager.h"
#import "Constants.h"
#import "NavigationBarLabel.h"
#import "UIAlertView+Blocks.h"
#import "AddBookViewController.h"
#import "Book.h"

@interface BookDetailViewController () <AddBookViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *bookInfoTextView;
@property (nonatomic, strong) AddBookViewController *addBookController;
@end

@implementation BookDetailViewController

#pragma mark - LifeCycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configureNavigationBar];
    [self updateUIWithBook:self.bookToShow];
}

#pragma mark - UISetup

-(void)configureNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareSheet)];
    
    NavigationBarLabel *label = [[NavigationBarLabel alloc]initWithText:@"Detail"];
    self.navigationItem.titleView = label;
}

-(void)updateUIWithBook:(Book *)book{
    
    self.bookTitleLabel.text = book.bookTitle;
    self.authorLabel.text = book.author;
    self.bookTitleLabel.font = [UIFont fontWithName:FONT_MAIN size:20.0f];
    self.authorLabel.font = [UIFont fontWithName:FONT_MAIN size:16.0f];
    [self configureTextViewUIFromBook:book];
}

-(void)configureTextViewUIFromBook:(Book *)book{
    
    NSString *dateString = book.lastCheckedOut;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd  HH':'mm':'ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
    NSString *formattedString = [dateFormatter stringFromDate:date];
    
    NSString *publisherString = book.publisher;
    NSString *formattedPublisherString = [publisherString isEqualToString:@"(null)"] ? @"Default": book.publisher;
    NSString *categoriesString = book.categories;
    NSString *formattedCategoriesString = [categoriesString isEqualToString:@"(null)"] ? @"Default": book.categories;
    
    self.bookInfoTextView.text = [NSString stringWithFormat:@"Publisher: %@\nTags: %@\n\nLast Checked Out:\n%@ @ %@", formattedPublisherString, formattedCategoriesString, book.lastCheckedOutBy, formattedString];
    
    self.bookInfoTextView.font = [UIFont fontWithName:FONT_MAIN size:14.0f];
    self.bookInfoTextView.textColor = [UIColor darkGrayColor];
    self.bookInfoTextView.textAlignment = NSTextAlignmentRight;
}

#pragma mark - Networking

-(void)updateCheckOutInfoWithUsername:(NSString *)username{
    
    [[NetworkManager sharedManager]updateCheckOutInfoWithUsername:username bookInfo:self.bookToShow completionBlock:^(Book *book) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithBook:book];
        });
    }];
}

#pragma mark - IBAction

-(void)showShareSheet{
    
    NSMutableArray *activityItems = [[NSMutableArray alloc]initWithObjects:@"This Book is Awesome!!", nil];
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:shareController animated:YES completion:nil];
}

- (IBAction)checkout:(id)sender {
    
    UIAlertView *alertView = [UIAlertView showWithTitle:@"Hi Visiter"
                                                message:@"Please enter your name"
                                                  style:UIAlertViewStylePlainTextInput
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@[@"Checkout"]
                                               tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString *username = [[alertView textFieldAtIndex:0]text];
            [self updateCheckOutInfoWithUsername:username];
        }
    }];
    
    [alertView show];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:SEGUE_SHOW_EDIT_IDENTIFIER]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController *navController = segue.destinationViewController;
            self.addBookController = (AddBookViewController *)navController.topViewController;
            self.addBookController.updatingBookInfo = YES;
            self.addBookController.currentBook = self.bookToShow;
            self.addBookController.delegate = self;
        }
    }
}

#pragma mark - AddBookViewControllerDelegate

-(void)userDidUpdateBookInformationWithDict:(Book *)book{
    [self updateUIWithBook:book];
}

@end
