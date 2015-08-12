//
//  BookTableViewCell.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "BookTableViewCell.h"
#import "Book.h"
#import <QuartzCore/QuartzCore.h>

@interface BookTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation BookTableViewCell

-(void)awakeFromNib{
    self.bgView.layer.cornerRadius = 2.0f;
    self.bgView.layer.shadowColor = [[UIColor darkGrayColor]CGColor];
    self.bgView.layer.shadowOpacity = 0.7f;
    self.bgView.layer.shadowOffset = CGSizeMake(0.1f, 0.3f);
    self.bgView.layer.shadowRadius = 2.0f;
}

-(void)configureCellWithBook:(Book *)book{
    self.bookTitleLabel.text = book.bookTitle;
    self.authorLabel.text = book.author;
}

@end
