//
//  BookTableViewCell.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "BookTableViewCell.h"
#import "Book.h"

@interface BookTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation BookTableViewCell

-(void)configureCellWithBook:(Book *)book{
    self.bookTitleLabel.text = book.bookTitle;
    self.authorLabel.text = book.author;
}

@end
