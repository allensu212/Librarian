//
//  BookDetailViewController.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "BookDetailViewController.h"

@interface BookDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *bookTitleTextView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *bookInfoTextView;

@end

@implementation BookDetailViewController

#pragma mark - LifeCycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configureNavigationBar];
    [self updateUIWithDict:self.bookData];
}

-(void)configureNavigationBar{
    self.navigationItem.title = @"Detail";
}

-(void)updateUIWithDict:(NSDictionary *)dict{
    self.bookInfoTextView.text = dict[@"title"];
    self.authorLabel.text = dict[@"author"];
    
    self.bookInfoTextView.text = [NSString stringWithFormat:@"Publisher: %@\nTags: %@\n\nLast Checked Out:\n%@ @ %@", dict[@"publisher"], dict[@"categories"], dict[@"lastCheckedOutBy"], dict[@"lastCheckedOut"]];
}

#pragma mark - IBAction

- (IBAction)checkout:(id)sender {
}

@end
