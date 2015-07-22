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
#import "NavigationBarLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface BookDetailViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *bookInfoTextView;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareSheet)];
    
    NavigationBarLabel *label = [[NavigationBarLabel alloc]initWithText:@"Detail"];
    self.navigationItem.titleView = label;
}

-(void)updateUIWithDict:(NSDictionary *)dict{
    
    self.bookTitleLabel.text = dict[@"title"];
    self.authorLabel.text = dict[@"author"];
    self.bookTitleLabel.font = [UIFont fontWithName:FONT_MAIN size:20.0f];
    [self configureTextViewUIFromDict:dict];
}

-(void)configureTextViewUIFromDict:(NSDictionary *)dict{
    
    NSString *dateString = dict[@"lastCheckedOut"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd  HH':'mm':'ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
    NSString *formattedString = [dateFormatter stringFromDate:date];
    
    self.bookInfoTextView.text = [NSString stringWithFormat:@"Publisher: %@\nTags: %@\n\nLast Checked Out:\n%@ @ %@", dict[@"publisher"], dict[@"categories"], dict[@"lastCheckedOutBy"], formattedString];
    self.bookInfoTextView.font = [UIFont fontWithName:FONT_MAIN size:14.0f];
    self.bookInfoTextView.textColor = [UIColor darkGrayColor];
    self.bookInfoTextView.textAlignment = NSTextAlignmentRight;
    
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
