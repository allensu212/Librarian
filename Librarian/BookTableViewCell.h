//
//  BookTableViewCell.h
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;

@interface BookTableViewCell : UITableViewCell

-(void)configureCellWithBook:(Book *)book;

@end
