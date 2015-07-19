//
//  Book.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "Book.h"

@implementation Book

-(instancetype)initWithTitle:(NSString *)title author:(NSString *)author publisher:(NSString *)publisher categories:(NSString *)categories{
    
    if (self = [super init]) {
        _bookTitle = title;
        _author = author;
        _publisher = publisher;
        _categories = categories;
    }
    return self;
}

@end
