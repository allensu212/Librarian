//
//  BookDetailViewController.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "BookDetailViewController.h"
#import "NetworkManager.h"
#import "UICustomAlertView.h"
#import "Constants.h"

@interface BookDetailViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *bookInfoTextView;
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NetworkManager *networkManager;
@end

@implementation BookDetailViewController

-(NetworkManager *)networkManager{
    if (!_networkManager) {
        _networkManager = [NetworkManager sharedManager];
    }
    return _networkManager;
}

#pragma mark - LifeCycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configureNavigationBar];
    [self updateUIWithDict:self.bookData];
}

-(void)configureNavigationBar
{
    self.navigationItem.title = @"Detail";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareSheet)];
}

-(void)updateUIWithDict:(NSDictionary *)dict{
    
    self.bookTitleLabel.text = dict[@"title"];
    self.authorLabel.text = dict[@"author"];
    self.bookInfoTextView.text = [NSString stringWithFormat:@"Publisher: %@\nTags: %@\n\nLast Checked Out:\n%@ @ %@", dict[@"publisher"], dict[@"categories"], dict[@"lastCheckedOutBy"], dict[@"lastCheckedOut"]];
    self.bookInfoTextView.font = [UIFont fontWithName:FONT_MAIN size:12.0f];
    self.bookTitleLabel.font = [UIFont fontWithName:FONT_MAIN size:16.0f];
    
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    [self configureBookCoverWithDict:dict];
}

-(void)configureBookCoverWithDict:(NSDictionary *)dict{
    
    [self.networkManager fetchBookCoverWithBookTitle:dict[@"title"] withCompletionBlock:^(NSString *coverURL, NSDictionary *jsonDict) {
        NSURL * imageURL = [NSURL URLWithString:coverURL];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bookCoverImageView.image = [UIImage imageWithData:imageData];
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;
        });
    }];
}

-(void)updateCheckOutInfoWithUsername:(NSString *)username{
    
    [self.networkManager updateCheckOutInfoWithUsername:username bookInfo:self.bookData[@"url"]completionBlock:^(NSDictionary *dataDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithDict:dataDict];
        });
    }];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *username = [[alertView textFieldAtIndex:0]text];
        [self updateCheckOutInfoWithUsername:username];
    }
}

#pragma mark - IBAction

-(void)showShareSheet{
    
    NSMutableArray *activityItems = [[NSMutableArray alloc]initWithObjects:UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, nil];
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:shareController animated:YES completion:nil];
}

- (IBAction)checkout:(id)sender {
    UICustomAlertView *alertView = [[UICustomAlertView alloc]initWithTitle:@"Hi Visiter" message:@"Please enter your name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Checkout", nil];
    [alertView show];
}

@end
