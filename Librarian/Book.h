//
//  Book.h
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, strong) NSString *bookTitle;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *publisher;
@property (nonatomic, strong) NSString *categories;

-(instancetype)initWithTitle:(NSString *)title author:(NSString *)author publisher:(NSString *)publisher categories:(NSString *)categories;

@end
