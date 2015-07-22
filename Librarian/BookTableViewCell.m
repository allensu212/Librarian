//
//  BookTableViewCell.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "BookTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface BookTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIView *dotView;

@end

@implementation BookTableViewCell

-(void)configureCellWithDict:(NSDictionary *)dict{
    self.dotView.layer.cornerRadius = self.dotView.frame.size.width / 2;
    self.bookTitleLabel.text = dict[@"title"];
    self.authorLabel.text = dict[@"author"];
}

@end
