//
//  Book.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "Book.h"

@implementation Book

-(instancetype)initWithTitle:(NSString *)bookTitle author:(NSString *)author publisher:(NSString *)publisher categories:(NSString *)categories lastCheckedOut:(NSString *)lastCheckedOut user:(NSString *)user url:(NSString *)url{
    if (self = [super init]) {
        _bookTitle = bookTitle;
        _author = author;
        _publisher = publisher;
        _categories = categories;
        _lastCheckedOut = lastCheckedOut;
        _lastCheckedOutBy = user;
        _url = url;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    
    Book *book = [[Book alloc] initWithTitle:self.bookTitle author:self.author publisher:self.publisher categories:self.categories lastCheckedOut:self.lastCheckedOut user:self.lastCheckedOutBy url:self.url];
    
    return book;
}

@end
