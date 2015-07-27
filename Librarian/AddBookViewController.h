//
//  AddBookViewController.h
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddBookViewController;
@class Book;

@protocol AddBookViewControllerDelegate <NSObject>

-(void)userDidUpdateBookInformationWithDict:(Book *)book;

@end

@interface AddBookViewController : UIViewController
@property (nonatomic, assign) BOOL updatingBookInfo;
@property (nonatomic, strong) Book *currentBook;
@property (nonatomic, weak) id<AddBookViewControllerDelegate>delegate;

@end
