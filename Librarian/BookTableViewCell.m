//
//  BookTableViewCell.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "BookTableViewCell.h"

@interface BookTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation BookTableViewCell

-(void)configureCellWithDict:(NSDictionary *)dict{
    self.bookTitleLabel.text = dict[@"title"];
    self.authorLabel.text = dict[@"author"];
}

@end
