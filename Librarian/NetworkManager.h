//
//  NetworkManager.h
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Book;

typedef void(^FetchBooksCompletionBlock)(NSMutableArray *booksArray);
typedef void(^UpdateCheckOutInfoCompletionBlock)(Book *book);
typedef void(^UpdateBookInfoCompletionBlock)(Book *updatedBook);
typedef void(^AddBookCompletionBlock)(void);
typedef void(^DeleteBookCompletionBlock)(void);
typedef void(^DeleteCollectionCompletionBlock)(NSArray *dataArray);


@interface NetworkManager : NSObject

+(NetworkManager *)sharedManager;

-(void)fetchBooksWithCompletionBlock:(FetchBooksCompletionBlock)callback;
-(void)updateCheckOutInfoWithUsername:(NSString *)username bookInfo:(Book *)book completionBlock:(UpdateCheckOutInfoCompletionBlock)callback;
-(void)updateBookInfo:(Book *)book withCompletionBlock:(UpdateBookInfoCompletionBlock)callback;
-(void)addNewBook:(Book *)newBook withCompletionBlock:(AddBookCompletionBlock)callback;
-(void)deleteBook:(Book *)book withCompletionBlock:(DeleteBookCompletionBlock)callback;
-(void)deleteAllBooksWithCompletionBlock:(DeleteCollectionCompletionBlock)callback;

@end
